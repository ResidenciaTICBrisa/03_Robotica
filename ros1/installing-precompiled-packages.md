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

If you're on a unsopported operating system or architecture, it will be
necessary to compile the ROS1 ecosystem.

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