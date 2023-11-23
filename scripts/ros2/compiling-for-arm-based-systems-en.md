# Compile ROS for a ARM-based SBC (Raspberry Pi and similar devices) on your computer

## Packages to install

```
qemu-system-arm
qemu-utils
qemu-user-static
binfmt-support
devscripts
libguestfs-tools
```

## Instructions

The scripts are configured by default to compile and create *chroots* based on
ROS2's expected Ubuntu installation: a Ubuntu 22.04 LTS system up-to-date with
its security repository.

There are variables that enable the modification to compile and generate
*chroots* for all GNU/Linux distributions supported by `debootstrap`.

### Bootstraping a chroot

This step is required if you wish to compile and install ROS2 on a ARM-based
SBC.

1. Run, with administrator priviledges,the script `bootstrap-chroot-32.sh` or
`bootstrap-chroot-64.sh`, depending on the Operating System installed on your
Single Board Computer. This step will be successfull if Git can be successfully
installed after authorising its installation.

### Compiling and installing on Ubuntu-based Systems

After setting the `chroot` up, you must run one of the compilation and
installation scripts. The version will depend on the architecture and the
operating system on your SBC.

1. Run, with administrator priviledges,the script
`ubuntu-compile-install-ros2-32.sh` or `ubuntu-compile-install-ros2-64.sh`,
depending on the Operating System installed on your Single Board Computer.
2. Authorise the operations inside the *chrooted* environment using the
`CHROOTED_USER`'s password defined in the `chroot-env-vars.sh` script.
3. ROS will be installed on the `CHROOTED_USER`'s home directory. Depending on
your operating system, you may need to install `ros-dev-tools` or a similar
package.

### Installing ROS2 Dependencies after compiling it

1. Copy the directory with the compiled results and the dependency scripts to
the target system.
2. Install the basic dependencies. This step depends on the operating system.
3. Run the dependency script `ros2-humble-packages.sh` to install the full list
of dependencies.

#### Installing the basic dependencies on Ubuntu 22.04 LTS (Jammy)

The following script will install the basic dependencies and run the dependency
script.

```bash
sudo apt install --yes git wget software-properties-common
sudo add-apt-repository --yes universe

sudo wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update

sudo apt install --yes ros-dev-tools

sudo ./ros2-humble-packages.sh
```