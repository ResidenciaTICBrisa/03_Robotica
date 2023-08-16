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
# old ca-certificates from Ubuntu 20 can't validate github's new certificate
sudo wget --no-check-certificate https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O /usr/share/keyrings/ros-archive-keyring.gpg
# Using sudo requires care when writing commands with shell redirections
# echo "data" > special-file
# echo "data" | sudo tee special-file > /dev/null
echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg arch=$(dpkg --print-architecture)] http://packages.ros.org/ros/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ros1.list > /dev/null
sudo apt update

# Install full ROS1
# 2D and 3D simulators and perception packages, rqt, rviz, ROS packaging, build,
# and communication libraries.
# as root
sudo apt install --yes ros-noetic-desktop-full
