# Compiling or installing ROS1 on Debian-based systems

Ubuntu 20.04 is the officially supported distribution for ROS1 Noetic.
Fortunately, unlike ROS2, ROS1 has been natively packaged by Debian and Ubuntu
in more architectures and distributions than ROS1 team officially supports.
It will be easier to follow our specific guides using compilation scripts
instead of doing everything manually:

- if you wish to install precompiled ROS1 packages compiled by ROS1 development
team for `arm64`, `amd64` or `armhf` machines, please follow our
[precompiled installation guide](./installing-precompiled-packages-en.md)
- if you wish to compile ROS1:
    - for `amd64` please follow our
    [amd64 compilation guide](./compiling-for-amd64-based-systems-en.md)
    - for `arm64` or `armhf` SBCs (Single Board Computers), like Raspberry and
    Orange Pi, Beaglebone, please follow our
    [SBC compilation guide](compiling-for-arm-based-systems-en.md)
- if you wish to install natively packaged ROS1 in your Debian-based operating
system, please follow our
[native package installation guide](./installing-native-packages-en.md)