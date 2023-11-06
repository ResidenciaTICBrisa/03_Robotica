# Set up and run a VM for developing NAOv4-based solutions

## Setup

The scripts are flexible, but they still have requirements in order to be run.

### Packages

These scripts need the following packages to be installed on the host's system
(assuming a Debian GNU/Linux based distribution, such as Ubuntu, Linux Mint):

|Package         |Version|
|----------------|-------|
|qemu-system-x86 |6.2.0  |
|qemu-utils      |6.2.0  |
|qemu-system-gui |6.2.0  |
|qemu-block-extra|6.2.0  |
|ovmf            |2022.02|
|libguestfs-tools|1.46.2 |
|iproute2        |5.15   |
|nftables        |1.0.2  |

The scripts assume that KVM-based accelerated virtualisation is enabled on the
host machine. This requires a compatible processor and it may require a
configuration in the UEFI/BIOS (AMD-V, AMD SVM, Intel VT, Intel VT-x,
Intel VMX).

The package `cpu-checker` is able to verify if KVM is correctly enabled: one
only needs to run the command `kvm-ok` as superuser.

### Expected directory structure

Even though these scripts can be modified easily, they expect the following
directory structure in their current form:

- `env-vars.sh`, a script to centralise the VM's configurations
- an [image][1] from Ubuntu's installation disk version 14.04 named as
`ubuntu-14.04-desktop-amd64.iso` (this can be altered in the `IMAGE_LOCATION`
variable at the `env-vars.sh` script)

[1]: https://releases.ubuntu.com/trusty/ubuntu-14.04.6-desktop-amd64.iso

The GNU/Linux distribution for fully installing NAOv4's programming environment
is Ubuntu 14.04 LTS. It is highly possible that one may be able to run it on the
equivalent Debian release.

If the user wishes to **only** develop programs using NAOv4's C++98 API, it
*may* be possible to use a newer GNU/Linux distribution, provided that it has
support for Python 2 and Pip 20.3.4.

### Creating the VM and preparing to compile NAOqi for NAOv4

The user must run in their host machine the scripts inside this repository in
the following order:

1. `reset-main-drive.sh`
2. `first-boot.sh`

After installing Ubuntu 14.04 in their virtual machine, the following scripts
must be executed in their host machine:

1. `update-sources.sh`
2. `inject-home.sh`

Now, inside the virtual machine, also known as the guest machine, the user
must run the `prepare-naoqi-requirements.sh` script to compile Python 2.7.11
and install Pip 20.3.4.

Finally, the user will be able to install the NAOv4 development environment
using the `install-naov4.sh` script. The newer Python will be used only to
download Pip, as it crashes the Python SDK.

## Starting the Virtual Machine up for the first time

The initial images are created by the `reset-main-drive.sh` and `first-boot.sh`
scripts. The former creates a QCOW2 image that will perform as the virtual
machine's or guest system's hard drive, and the latter will boot the VM with
the Ubuntu 14 LTS installation disk.

With the drives created, run the initialisation script and install a regular
Ubuntu 14.04 LTS installation:

- Language and keyboard layout: Português Brasileiro (or other UTF-8 locale)
- Erase disk and install Ubuntu
- Timezone: Sao Paulo (or your local timezone)
- User: softex (must be the one specified in `VM_USER` in `env-vars.sh`)

### WARNING

The scripts expect an *unified root* partition scheme. Do not split `/home` or
other directories into other partitions unless you know how to modify the
scripts that copy data into or from the virtual machine or guest system.

## Running the VM

Sometimes the Brazilian server takes too long to synchronise with the main
server, leading to failed installations or upgrades. In order to avoid this
problem, please run the following script to set the repository to the main
archive:

```
./update-sources.sh
```

Don't forget to update (`apt-get update`) and upgrade (`apt-get dist-upgrade`)
if there are any updates available.

### How to reclaim unused memory from the Virtual Machine

If you are running the virtual machine on a memory constrained host, we
recommend you to use the included `virtio-balloon` functionality. This will
recover unused memory from the virtual machine (the guest) and return it to your
computer (the host).

A balloon driver is a special driver included on the kernels of some operating
systems that helps the hypervisors, programs used to run virtual machines, to
recover unused memory from their guests. This drivers offers two operations: a
balloon inflation and a deflation.

The inflation procedure is used to reclaim unused memory: it orders the driver
to create memory pressure on the guest machine, triggering a page update. This
decreases the available memory in the guest, but it enables the host to reclaim
any unused pages.

The deflation procedure increases the available memory on the guest up its
configured physical memory limit. It is commonly used after an inflation
procedure to allow the virtual machine to use its configured physical memory.

#### How to use the QEMU's balloon driver

The QEMU's balloon driver is controlled in the QEMU monitor on the
implementation offered by the scripts. The `balloon` command takes an argument
that specifies the target logical size of the virtual machine:

- if the argument is less than the physical memory configured for the VM, the
balloon will be inflated in the guest, and any unused pages will be reclaimed;
- if the argument is equal or greater than the guest's physical memory, the
balloon will be deflated until it no longer restricts the virtual machine's
physical memory.

Please be aware that the `virtio-balloon` does not require the installation of
any external driver on most GNU/Linux-based guests, as it is included in the
kernel since 2008 (version 2.6.25).

It is important to always have in mind that the balloon inflation operation
should only be performed when the virtual machine is not under memory pressure.
This means that you should only try to recover **unused** memory from the
VM when it has a healthy amount of free memory to keep running without needing
to swap.

## Preparing to install NAOqi for NAOv4

Ubuntu 14.04 has an old version of Python 2.7. It lacks support to download data
from websites that enforce HTTPS, such as the modern Python packages index
(`pip`). This requires a compilation of a newer Python version and the
installation of the last compatible `pip` release. These steps can be automated
by sending a script to the user's home on the VM:

```
./inject-home.sh
```

After the script is sent to the user's home, it must be executed in the VM. It
will propmpt for administrative privileges before updating the repository and
installing dependencies for compiling and installing Python 2 and Pip:

```
./prepare-naoqi-requirements.sh
```

## Installing NAOv4 development environment

After running the preparation script, the installation one must be run on a
new terminal session. If you wish to remain in the same session, you must reload
your `.bashrc` (`source .bashrc`) to enable the modifications made to redirect
Python 2 to a newer version and to enable PIP2 and its binaries.

```
./install-naov4.sh
```

This script will also prompt for administrative rights, as it needs to install
packages used by the C++ and Python2 SDKs.

### Activating Choregraphe

Choregraphe will prompt for its activation key on its first initialisation. This
key is available in the installation script, and it will also be printed to the
terminal after the script is executed.

### Configuring the host USB

The `env-vars.sh` script has four variables to control how the virtual machine
will connect to the host USB device:

- `USB_HOST_BUS`: the bus' ID, including leading zeros
- `USB_HOST_ADDRESS`: the device's ID in the aforementioned bus, including leading
zeros
- `USB_VENDOR_ID`: the device's vendor ID in hexadecimal notation, that is, the
device's vendor ID preceded by `0x`
- `USB_PRODUCT_ID`: the device's product ID in hexadecimal notation, that is,
the device's product ID preceded by `0x`

The variables match the output of the `lsusb` command:

```
Bus $USB_HOST_BUS Device $USB_HOST_ADDRESS: ID $USB_VENDOR_ID:$USB_PRODUCT_ID MyUSB Device Thing
```

There are two scripts that will connect the host's device to the virtual
machine:

- `run-usb-productid.sh`: connects only the device with the matching vendor and
product ID as long as it is connected to the specified port. It requires
specifying all the four variables;
- `run-usb-hostid.sh`: connects anything currenctly connected to the specified
port. It requires specifying only the bus and the device.

The virtualiser uses the `/dev/bus/usb` files to connect the VM to the host
device. This requires superuser permissions on most machines. In order to
connect a host USB device to the VM, the user must provide the script with the
necessary privileges (run it as root, prefix with `sudo`) or change the
permissions of the USB interface (changing its group with `chgrp` to a group
that it user takes part in, or changing its owner with `chown`).

#### Example

Consider the following `lsusb` output:

```
Bus 001 Device 001: ID 0001:0001 USB Thing 1
Bus 001 Device 002: ID 0001:0002 USB Thing 2
Bus 001 Device 003: ID 0001:0001 USB Thing 1
Bus 002 Device 001: ID 0002:0001 USB Device 1
Bus 002 Device 002: ID 0002:0002 USB Device 2
Bus 002 Device 003: ID 0002:0001 USB Device 1
```

If one wishes to connect the `USB Thing 1` connected at the `Bus 001` as the
device numbered `003`, they should configure the variables at `env-vars.sh` as:

```
USB_HOST_BUS="001"
USB_HOST_ADDRESS="003"
USB_VENDOR_ID="0x0001"
USB_PRODUCT_ID="0x0001"
```

Before running the desired script, the permissions must be set for the USB file
(`chown the-user /dev/bus/usb/001/003`) or the script must be run with elevated
privileges (`sudo` or run as root).

Please be aware that in order to connect only the required device to the VM, one
must run the VM using `run-usb-productid.sh`. Choosing the
`run-usb-productid.sh` would connect all the devices connected to the `Bus 001`,
the two `USB Thing 1` and the `USB Thing 2`.

### NAO Flasher permissions

NAO Flasher requires administrative permissions (`sudo` or execution as the
`root` user) to write data. If `sudo` can't find the program's path, you may
find it with `command -v flasher`.

## Compiling C++ code

The qibuild framework requires that all projects must be based inside a
worktree. The configuration script creates a worktree inside the
`NAO4/worktree` directory. It is configured with the C++ SDK as the default
toolchain, and the CTC is also available if the user wishes to set up their
projects as so.

The *worktree* path is stored in the user's `.bashrc` in the
`NAO_QIBUILD_WORKSPACE` variable.

### Qibuild configuration

The script sets up the configurations' names in the user's `.bashrc`. The
following environment variables hold data important for setting up qibuild-based
projects:

- `NAOQI_CPP_QIBUILD_TOOLCHAIN`: the name of the toolchain used when it was
added to the *worktree*.
- `NAOQI_CPP_QIBUILD_CONFIG`: the name of the configuration generated after the
SDK was added to the *worktree*. It is the default toolchain configuration.
- `NAOQI_QIBUILD_CTC`: the name of the cross toolchain in the *worktree*.
- `NAOQI_QIBUILD_CTC_CONFIG`: the name of the configuration in the *worktree*.
It can be used to replace the C++ SDK as the project's toolchain in order to
create a binary that can be transfered to the robot.

### Basic project setup

The following steps will create and build a C++ SDK-based project on the
configured *worktree*:

```bash
cd "${NAO_QIBUILD_WORKSPACE}"
qisrc create my-project
cd my-project
qibuild configure
qibuild make
```

The C++ SDK is configured as the default toolchain. If you wish to set up a
project with an explicit configuration and build setup, you may run:

```bash
cd "${NAO_QIBUILD_WORKSPACE}"
qisrc create my-project
cd my-project
qibuild configure -c "${NAOQI_CPP_QIBUILD_CONFIG}" my-project
qibuild make -c "${NAOQI_CPP_QIBUILD_CONFIG}" my-project
```

Compiling a project that will be run on the robot requires an explicit
configuration to replace the default toolchain by the cross-compilation one
(NAO CTC):

```bash
cd "${NAO_QIBUILD_WORKSPACE}"
qisrc create my-project
cd my-project
qibuild configure -c "${NAOQI_QIBUILD_CTC_CONFIG}" 
qibuild make -c "${NAOQI_QIBUILD_CTC_CONFIG}" 
```

## Connecting to the simulated robot

The simulated robot is an executable located in the C++ toolchain directory
named `naoqi`. Provided that the tools were installed with the aforementioned
scripts in their default configuration, it will be located at
`/home/softex/NAO4/SDKs/cpp/naoqi-sdk-2.1.4.13-linux64/naoqi`.

The simulated robot must always be initialised before running Choregraphe or
your desired module. It will behave similarly to a physical robot, except by its
lack of cameras, and it will by default initialise its *broker* at *localhost*,
also known as IPv4 127.0.0.1, at the port 9559.

### Simulating in Choregraphe

If you wish to simulate your C++ module in Choregraphe, first you should start
the simulated `naoqi`. After doing it, then you must open Choregraphe, and
connect it to the broker available at 127.0.0.1 port 9559.

After these steps you should see a 3D simulation of a NAO robot in the
Robot View panel. At this stage you are ready to connect to the simulated robot
and check how it behaves in the simplified simulation offered by Choregraphe.

## Connecting to the robot

There are three scripts that are used when connecting the Virtual Machine to
your NAO:

1. `enable-nat-bridge-network.sh`: this script must be run with elevated
privileges to set a bridge with a bound DHCP server and a NAT masquerade up
2. `run-nat-bridge.sh`: this script executes the VM with connectivity to the
previously configured bridge. This is achieved by a `tap` device that QEMU will
automatically add to the bridge using `/usr/lib/qemu/qemu-bridge-helper` and
`/etc/qemu/bridge.conf`. It may be executed by a common user.
3. `disable-nat-bridge-network.sh`: this script must be run with elevated
privileges to undo all the modifications made by the NAT enabler script.

### Warning to Docker users

Docker overrides all user firewall configurations. The scripts currently
require a standard firewall configuration, so it will be necessary to remove
all tables and rules created by Docker. It is recommended to stop Docker with
`systemctl stop docker.service docker.socket` to avoid a surprise firewall
reconfiguration event.

You should be able to reset nftables to its standard configuration using the
command: `nft flush ruleset`. This will break the network for the containers
until the machine or the Docker service unit are restarted.

## How to manually add files to the Virtual Machine

You may want to add files from the host system, your current machine, to the
guest one, stored in the virtual machines. An usual way to do it is through SSH,
but it requires configuring an SSH server in the guest and a client in the host.

A quicker way is to add the files directly to the virtual machine images. This
approach requires that the VMs must not be in execution, unlike the SSH-based
one. It is most convenient to use `guestfish`, a system shell that specialises
in manipulating virtual machine images, to manually add files to the VMs.

You may create a script based on `inject-home.sh`, or use `guestfish` on its
interactive mode, which works similarly to the usual system shell. Even though
it requires more typing, the latter approach is more user-friendly and will be
explored in this tutorial.

Firstly, you must know the path to the files that you wish to add to your VM and
their desired location in the virtual machine. These will be parameters that
will be used in `guestfish`'s `copy-in` command, responsible for copying files
*into* the VM.

Then you must mount the virtual machine's partition that holds the output path.
This is the more cumbersome stage, as it requires knowing which partitions are
included in the virtual machine's image file. If you followed the previous
instructions and installed the VM using the recommended settings, you will be
able to use the following commands after executing `guestfish` on your terminal
with the working directory pointing where the image is located:

```
<!. ./env-vars.sh > /dev/null; echo "add '${DISK_LOCATION}'"
run
mount '/dev/sda1' '/'
```

With the main partition mounted, you may use the `ls` command to list files and
directories. Copying files into the VM is done though the `copy-in` command:

```
# copying a file or directory from the current host directory
copy-in my-file-or-directory /home/softex
# copying a file or directory from an absolute path in the host
copy-in /absolute/path/in/the/host/something /desired/path/in/the/vm
```

The scripts use a more complicated syntax to automatically obtain the user that
has been configured in the `env-vars.sh` file:

```
<!. ./env-vars.sh > /dev/null; echo "copy-in 'my-file' '/home/${VM_USER}/abc'"
```

After copying all the desired files, do not forget to unmount all the partitions
and close `guestfish` before running the VM:

```
umount-all
exit
```