# Installing precompiled ROS1 from ROS repositories

If you're using one of the currently supported operating systems, you will be
able to install precompiled binary packages from ROS1 repositories.

## Compatible operating systems

ROS1 currently packages the ROS ecosystem for the following combinations of
operating systems and architectures:

- Ubuntu 20.04 LTS (focal)
    - amd64
        - ros-noetic-ros-base
        - ros-noetic-desktop
        - ros-noetic-desktop-full
    - arm64
        - ros-noetic-ros-base
        - ros-noetic-desktop
        - ros-noetic-desktop-full
    - armhf
        - ros-noetic-ros-base
        - ros-noetic-desktop
- Debian 10 (buster)
    - amd64
        - ros-noetic-ros-base
        - ros-noetic-desktop
        - ros-noetic-desktop-full
    - arm64
        - ros-noetic-ros-base
        - ros-noetic-desktop

If you're on a unsopported operating system or architecture, it will be
necessary to compile the ROS1 ecosystem.

### WARNING!

ROS2 precompiled packages are notorious for breaking systems when installed
without upgrading the system [1][1] [2][2]! Although the installation scripts
follow the recommended procedures, and ROS1 does not cite that the same problem
exists for their packages, the risk remains!

You **MUST** have the security repository enabled, as ROS packages are not
tested on a standard Debian packaging environment and assume that this
repository will be enabled and that the system is up to date. Please note that
for Ubuntu, the security repository is different for `amd64` or `armhf`/`arm64`:

- Ubuntu Focal
    - Security repository for `amd64`:
`deb http://security.ubuntu.com/ubuntu focal-security main`
    - Security repository for `arm64` and `armhf`:
`deb http://ports.ubuntu.com/ubuntu-ports focal-security main`
- Debian Buster
    - Security repository for `amd64`, `i386`, `arm64` and `armhf`:
`deb https://security.debian.org/debian-security buster/updates main`

The precompiled packages also have chronic problems with dependencies even when
installed on the supported configurations [3][3] [4][4]. If the
installation fails due to dependency problems, it is advised to compile ROS1
from source or, if possible, installing the distribution's native packages
instead of trying to fight the unsatisfiable dependencies.

[1]: https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html
[2]: https://github.com/ros2/ros2/issues/1272
[3]: https://github.com/ros2/ros2/issues/1433
[4]: https://github.com/ros2/ros2/issues/1287

## Instructions for supported systems

### Bootstraping a chroot

This step is required only if you wish to test the installation of ROS2 on a
ARM-based SBC. The script can be modified to test the installation on an amd64
Debian-based distribution.

1. Run, with administrator priviledges,the script `bootstrap-chroot-32.sh` or
`bootstrap-chroot-64.sh`, depending on the Operating System installed on your
Single Board Computer. This step will be successfull if Git can be successfully
installed after authorising uts installation.

### Installing on Ubuntu-based Systems

You must run one of the installation scripts. The version will depend on the
architecture and the operating system on your machine.

Due to limited support of ROS1, this repository only supports 64-bit based ARM
or AMD64, or 32-bit based ARM (armhf) although the scripts can be easily
modified to support other architectures and Debian-based operating systems as
soon as they are available.

1. If you are in a **chroot**, please run, with administrator priviledges, the
scripts `ubuntu-install-ros1-32-base.sh`, `ubuntu-install-ros1-32-desktop.sh`,
`ubuntu-install-ros1-64-base.sh`, `ubuntu-install-ros1-64-desktop.sh`,
`ubuntu-install-ros1-64-desktop-full.sh` depending on the ROS1 packages you wish
to install.
2. Authorise the administrative-level operations using your password.