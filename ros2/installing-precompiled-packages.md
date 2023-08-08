# Installing precompiled ROS2 from ROS repositories

If you're using one of the currently supported operating systems, you will be
able to install precompiled binary packages from ROS2 repositories.

## Compatible operating systems

ROS2 currently packages the ROS ecosystem for the following combinations of
operating systems and architectures:
- Ubuntu 22.04 LTS (Jammy)
  - amd64
  - arm64

If you're on a unsopported operating system or architecture, it will be
necessary to compile the ROS2 ecosystem.

### WARNING!

ROS2 precompiled packages are notorious for breaking systems when installed
without upgrading the system [1][1] [2][2]! Although the installation scripts
follow the recommended procedures, the risk remains!

The precompiled packages also have chronic problems with dependencies even when
installed on the supported Ubuntu configuration [3][3] [4][4]. If the
installation fails due to dependency problems, it is advised to compile ROS2
from source instead of trying to fight the unsatisfiable dependencies.

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

Due to limited support of ROS2, this repository only supports 64-bit based ARM
or AMD64, although the scripts can be easily modified to support other
architectures and operating systems as soon as they are available.

1. If you are in a **chroot**, please run, with administrator priviledges, the
scripts `ubuntu-install-ros2-64-base.sh` or `ubuntu-install-ros2-64-desktop.sh`
depending on the ROS2 packages you wish to install. If you are in a regular
installation, please run the scripts `ubuntu-install-ros2-humble-base.sh` or
`ubuntu-install-ros2-humble-desktop.sh`.
2. Authorise the administrative-level operations using your password.