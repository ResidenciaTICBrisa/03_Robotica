#!/bin/bash

# Recommended for a machine with 16 GB of RAM. Trying to go above 8 workers will
# require more RAM if you do not wish to suffer severe slowdowns due to the
# trashing or to be surprised with the consequences of triggering the OOM
# killer.
# Colcon doesn't really know what should be parallelised, so you will still get
# ${WORKERS} workers fighting to use all the available cores at once. This
# causes unnecessary context switches and plenty of cache misses.
# Going lower or configuring the sequential executor is not recommended, as
# colcon will refuse to parallelise the lengthy single threaded installation
# phases, which will waste time on a machine with a SSD or fast HDDs.
# If you somehow forget to set this variable, the script will try to use the
# default value detected by colcon, the number of available processors. This
# includes the SMT threads, if they are available.
readonly WORKERS=8

if command -v locale > /dev/null; then
	if grep --quiet 'UTF-8' <<< "$(locale)"; then
		echo "UTF-8 locale found"
	else
		echo "No UTF-8 locales found! Installation may FAIL!"
		echo "Proposed solution:"
		echo "Run 'sudo dpkg-reconfigure locales'"
		echo "Select an UTF-8 locale"
		echo "Set an UTF-8 locale as the default"
		echo "Log off and log in before rerunning this script"
		exit 1
	fi
else
	echo "Please install 'locales' package"
	exit 2
fi

# Tools to download code
# as root
sudo apt install --yes git wget software-properties-common
sudo add-apt-repository --yes universe

# ROS repositories where the old python3-vcstool lives
# THIS WILL OVERWRITE ROS-RELATED SYSTEM PACKAGES!
# as root
sudo wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O /usr/share/keyrings/ros-archive-keyring.gpg
# Using sudo requires care when writing commands with shell redirections
# echo "data" > special-file
# echo "data" | sudo tee special-file > /dev/null
echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg arch=$(dpkg --print-architecture)] http://packages.ros.org/ros/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ros1.list > /dev/null
sudo apt update

# Tools to download and compile ROS-related code
# as root
sudo apt install --yes ros-dev-tools python3-rosinstall-generator

# Create a workspace and clone all repos
# as other user
mkdir -pv ros1_noetic/src
cd ros1_noetic
rosinstall_generator desktop --rosdistro noetic --deps --tar > noetic-desktop.rosinstall
vcs import --input noetic-desktop.rosinstall src

# Install even more dependencies
# as root
sudo rosdep init
# as other user
rosdep update
rosdep check --from-paths src --ignore-src -y --rosdistro noetic
printf '#!/bin/bash\n' > ros1-noetic-packages.sh
printf 'apt install --yes' >> ros1-noetic-packages.sh
perl -ne 'print " $+{package}" if /apt\s(?<package>.+)/' <<< "$(rosdep check --from-paths src --ignore-src -y --rosdistro noetic 2>/dev/null)" >> ros1-noetic-packages.sh
chmod +x ros1-noetic-packages.sh
# as root
sudo ./ros1-noetic-packages.sh

# Build the code
# Colcon needs pty devices or it will die before compiling anything.
# If you're building in a chrooted environment, you must bind mount the required
# devices.
# as other user
# Fixing permissions is not needed if you're compiling as someone other than the
# super-user.
# rosdep fix-permissions
rosdep update
rosdep check --from-paths src --ignore-src -y --rosdistro noetic

if [[ "$(dpkg --print-architecture)" =~ "amd64" ]]; then
	echo "Build results will be available at 'install' directory"
	colcon build --parallel-workers "${WORKERS:=$(nproc)}"
else
	# colcon cannot build xmlrpcpp on armhf or arm64
	echo "WARNING: colcon build of ROS1 is broken on armhf and arm64"
	echo "Falling back to the recommended legacy catkin_make_isolated"
	echo "Build results will be available at 'install_isolated' directory"
	./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --jobs "${WORKERS:=$(nproc)}"
fi
