#!/bin/bash

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
# Pay close attention!
# echo "data" > special-file
# echo "data" | sudo tee special-file > /dev/null
echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update

# Tools to download and compile ROS-related code
# as root
sudo apt install --yes ros-dev-tools

# Create a workspace and clone all repos
# as other user
mkdir -p ros2_humble/src
cd ros2_humble
vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src

# Install even more dependencies
# as root
sudo rosdep init
# as other user
echo '#!/bin/bash' > ros2-humble-packages.sh
perl -ne 'print "apt install --yes $1\n" if /apt\s(?<package>.+)/' <<< "$(rosdep check --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers" 2>/dev/null)" >> ros2-humble-packages.sh
chmod +x ros2-humble-packages.sh
# as root
sudo ./ros2-humble-packages.sh

# Build the code
# Colcon needs pty devices or it will die before compiling anything
# If you're building in a chrooted environment, you must bind mount the required devices
# as other user
rosdep fix-permissions
rosdep update
rosdep check --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"
colcon build
