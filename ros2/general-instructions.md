# Manually compiling and installing ROS2

How to manually compile and install ROS2 from its source code. We recommend
adapting the compilation scripts instead of doing everything manually.

## Regular installation instructions

As stated in the ROS2 Humble
[source installation documentation](https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html). This approach compiles software that already exists on
Debian repositories or that is not relevant to the system.

Due to ROS insisting on using packages from their repositories, even when Debian
or Ubuntu builds the same package from the same source, this approach requires
uninstalling the native version to allow `rosdep` to install some renamed
dependencies.

### Generating the chroot

```
debootstrap bookworm ./bookworm-chroot http://deb.debian.org/debian
# Do not bind mount /sys/firmware/efi/efivars
# Do not bind mount /dev
for i in /dev/pts /proc /sys /run; do sudo mount -B $i $(pwd)/bookworm-chroot$i; done
chroot bookworm-chroot
```

### Deactivating the bound mounts

When you leave the *chroot*, do not forget to unmount the directories that were
bind-mounted to it.

```
for i in /dev/pts /proc /sys /run; do umount $(pwd)/bookworm-chroot$i; done
```

### Compiling

```
# Tools to download code
apt install git colcon python3-rosdep2 vcstool wget

# ROS repositories where the old python3-vcstool lives
# THIS WILL OVERWRITE ROS-RELATED SYSTEM PACKAGES!
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu bookworm main" > /etc/apt/sources.list.d/ros2.list
apt update

# Common dependencies
apt install python3-flake8-docstrings python3-pip python3-pytest-cov

# Other dependencies
apt install python3-flake8-blind-except python3-flake8-builtins python3-flake8-class-newline python3-flake8-comprehensions python3-flake8-deprecated python3-flake8-import-order python3-flake8-quotes python3-pytest-repeat python3-pytest-rerunfailures

# Create a workspace and clone all repos
mkdir -p ros2_humble/src
cd ros2_humble
vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src

# Install even more dependencies
# rosdep init
rosdep update

# Broken python3-vcstools (rosdep thinks it is  python3-vcstool)
apt remove vcstool
rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

# Build the code
# Colcon needs pty devices or it will die before compiling anything
# If you're building in a chrooted environment, you must bind mount the required devices
cd ros2_humble/
colcon build

# Source the build script
# Replace ".bash" with your shell if you're not using bash
# Possible values are: setup.bash, setup.sh, setup.zsh
. ros2_humble/install/local_setup.bash

# Try the examples
. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_cpp talker

. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_py listener
```

## Instructions based on those from Debian Wiki

Instructions adapted from
[Debian's Wiki](https://wiki.debian.org/DebianScience/Robotics/ROS2) and the
current ROS LTS release,
[Humble Hawksbill](https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html).

This approach removes unnecessary artifacts from the build phase, as most of
them are already compiled in Debian or are not relevant for compiling and
installing ROS2 in the system.

### Generating the chroot

```
debootstrap bookworm ./bookworm-chroot-wiki http://deb.debian.org/debian
# Do not bind mount /sys/firmware/efi/efivars
# Do not bind mount /dev
for i in /dev/pts /proc /sys /run; do sudo mount -B $i $(pwd)/bookworm-chroot-wiki$i; done
chroot bookworm-chroot-wiki
# Create softex user with softex as a password
useradd --home-dir '/home/softex' --skel '/etc/skel' --create-home --shell '/bin/bash' softex
chpasswd <<< 'softex:softex'
```

### Deactivating the bound mounts

When you leave the *chroot*, do not forget to unmount the directories that were
bind-mounted to it.

```
for i in /dev/pts /proc /sys /run; do umount $(pwd)/bookworm-chroot-wiki$i; done
```

### Compiling

```
# Check UTF-8 support
# as root
if command -v locale > /dev/null; then
    if grep --quiet 'UTF-8' <<< "$(locale)"; then
        echo "UTF-8 locale found"
    else
        echo "No UTF-8 locales found! Installation may FAIL!"
    fi
else
    echo "Please install 'locales' package"
fi

# Tools to download code
# as root
apt install git colcon python3-rosdep2 vcstool wget

# Create a workspace and clone all repos
# as other user
mkdir -p ros2_humble/src
cd /home/softex/ros2_humble
wget https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos
# Remove what is already packaged in Debian
sed -i '/\(ament\|eProsima\|eclipse\|ignition\|osrf\|tango\|urdfdom\|tinyxml_\|loader\|pluginlib\|rcutils\|rcpputils\|test_interface\|testing_tools\|fixture\|rosidl:\)/,+3d' ros2.repos
vcs import src < ros2.repos

# Install even more dependencies
rosdep update
# as root
cd /home/softex/ros2_humble
rosdep update

# as root
rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

# Build the code
# Colcon needs pty devices or it will die before compiling anything
# If you're building in a chrooted environment, you must bind mount the required devices
# as other user
cd /home/softex/ros2_humble
rosdep fix-permissions
rosdep update
colcon build

# Source the build script
# Replace ".bash" with your shell if you're not using bash
# Possible values are: setup.bash, setup.sh, setup.zsh
. ros2_humble/install/local_setup.bash

# Try the examples
. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_cpp talker

. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_py listener
```

## Adapted Debian Wiki instructions on Ubuntu 22

### Generating the chroot

```
debootstrap jammy ./ubuntu-jammy-chroot-wiki http://archive.ubuntu.com/ubuntu/
# Do not bind mount /sys/firmware/efi/efivars
# Do not bind mount /dev
# Do not bind mount /run
for i in /dev/pts /proc /sys; do mount -B $i $(pwd)/ubuntu-jammy-chroot-wiki$i; done
chroot ubuntu-jammy-chroot-wiki
# Create softex user with softex as a password
useradd --home-dir '/home/softex' --skel '/etc/skel' --create-home --shell '/bin/bash' --groups 'sudo' softex
chpasswd <<< 'softex:softex'
```

### Deactivating the bound mounts

When you leave the *chroot*, do not forget to unmount the directories that were
bind-mounted to it.

```
for i in /dev/pts /proc /sys; do umount $(pwd)/ubuntu-jammy-chroot-wiki$i; done
```

### Compiling

```
# as root
if command -v locale > /dev/null; then
    if grep --quiet 'UTF-8' <<< "$(locale)"; then
        echo "UTF-8 locale found"
    else
        echo "No UTF-8 locales found! Installation may FAIL!"
    fi
else
    echo "Please install 'locales' package"
fi

# Tools to download code
# as root
apt install --yes git wget software-properties-common
add-apt-repository --yes universe

# ROS repositories where the old python3-vcstool lives
# THIS WILL OVERWRITE ROS-RELATED SYSTEM PACKAGES!
# as root
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2.list
apt update

# Tools to download and compile ROS-related code
# as root
apt install --yes ros-dev-tools

# Create a workspace and clone all repos
# as other user
mkdir -p ros2_humble/src
cd /home/softex/ros2_humble
vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src

# Install even more dependencies
# as root
cd /home/softex/ros2_humble
rosdep check --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"
rosdep init
#rosdep update

# other user
cd /home/softex/ros2_humble
echo '#!/bin/bash' > ros2-humble-packages.sh
perl -ne 'print "apt install --yes $1\n" if /apt\s(?<package>.+)/' <<< "$(rosdep check --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers" 2>/dev/null)" >> ros2-humble-packages.sh

# Install even more ROS-related dependencies
# as root
cd /home/softex/ros2_humble
chmod +x packages.sh
./packages.sh
# The packages list replaces the usual rosdep install
# rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

# Build the code
# Colcon needs pty devices or it will die before compiling anything
# If you're building in a chrooted environment, you must bind mount the required devices
# as other user
cd /home/softex/ros2_humble
rosdep fix-permissions
rosdep update
rosdep check --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"
colcon build

# Source the build script
# Replace ".bash" with your shell if you're not using bash
# Possible values are: setup.bash, setup.sh, setup.zsh
. ros2_humble/install/local_setup.bash

# Try the examples
. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_cpp talker
ros2 run demo_nodes_py listener
```

## Installation script on Ubuntu 22

### Generating the chroot

```
debootstrap jammy ./ubuntu-jammy-chroot-wiki http://archive.ubuntu.com/ubuntu/
# Do not bind mount /sys/firmware/efi/efivars
# Do not bind mount /dev
# Do not bind mount /run
for i in /dev/pts /proc /sys; do mount -B $i $(pwd)/ubuntu-jammy-chroot-wiki$i; done
chroot ubuntu-jammy-chroot-wiki
# Create softex user with softex as a password
useradd --home-dir '/home/softex' --skel '/etc/skel' --create-home --shell '/bin/bash' --groups 'sudo' softex
chpasswd <<< 'softex:softex'
```

### Deactivating the bound mounts

When you leave the *chroot*, do not forget to unmount the directories that were
bind-mounted to it.

```
for i in /dev/pts /proc /sys; do umount $(pwd)/ubuntu-jammy-chroot-wiki$i; done
```

### Compiling

```
./install-ros2-humble.sh
```

### Testing the instalation

```
# Source the build script
# Replace ".bash" with your shell if you're not using bash
# Possible values are: setup.bash, setup.sh, setup.zsh
. ros2_humble/install/local_setup.bash

# Try the examples
. ros2_humble/install/local_setup.bash
ros2 run demo_nodes_cpp talker
ros2 run demo_nodes_py listener
```