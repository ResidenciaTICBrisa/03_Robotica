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

1. Run, with administrator priviledges,the script `bootstrap-chroot-32.sh` or
`bootstrap-chroot-64.sh`, depending on the Operating System installed on your
Single Board Computer. This step will be successfull if Git can be successfully
installed after authorising uts installation.
2. Run, with administrator priviledges,the script `install-ros2-32.sh` or
`install-ros2-64.sh`, depending on the Operating System installed on your
Single Board Computer.
3. Authorise the operations inside the *chrooted* environment using the
`CHROOTED_USER`'s password defined in the `chroot-env-vars.sh` script.
4. ROS will be installed on the `CHROOTED_USER`'s home directory. Depending on
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