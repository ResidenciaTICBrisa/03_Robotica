# Set up and run a VM for developing NAOv6-based solutions

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
|ovmf            |2022.11|
|libguestfs-tools|1.48.6 |

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
- an [image][1] from Ubuntu's installation disk version 16.04 named as
`ubuntu-16.04-desktop-amd64.iso` (this can be altered in the `IMAGE_LOCATION`
variable at the `env-vars.sh` script)

[1]: https://releases.ubuntu.com/releases/xenial/ubuntu-16.04.7-desktop-amd64.iso

### Creating the VM and preparing to compile NAOqi for NAOv6

The user must run in their host machine the scripts inside this repository in
the following order:

1. `reset-main-drive.sh`
2. `first-boot.sh`

After installing Ubuntu 16.04 in their virtual machine, the following scripts
must be executed in their host machine:

1. `update-sources.sh`
2. `inject-home.sh`

Now, inside the virtual machine, also known as the guest machine, the user
must run the `prepare-naoqi-requirements.sh` script to install Pip 20.3.4.

Finally, the user will be able to install the NAOv6 development environment
using the `install-naov6.sh` script.

## Starting the Virtual Machine up for the first time

The initial images are created by the `reset-*` scripts

```
./reset-main-drive.sh
```

With the drives created, run the initialisation script and install a regular
Ubuntu 16.04 LTS installation:

- Language and keyboard layout: Português Brasileiro
- Erase disk and install Ubuntu
- Timezone: Sao Paulo
- User: softex

```
./first-boot.sh
```

## Running the VM

Sometimes the Brazilian server takes too long to synchronise with the main
server, leading to failed installations or upgrades. In order to avoid this
problem, please run the following script to set the repository to the main
archive:

```
./update-sources.sh
```

Don't forget to update (`apt update`) and upgrade (`apt dist-upgrade`) if there
are any updates available.

## Preparing to install NAOqi for NAOv6

Ubuntu 16.04 has an old version of `pip`. This requires an installation of the
last Python 2 compatible release to be able to download the packages and their
dependencies. These steps can be automated by sending a script to the user's
home on the VM:

```
./inject-home.sh
```

After the script is sent to the user's home, it must be executed in the VM. It
will propmpt for administrative privileges before updating the repository and
installing dependencies for installing Pip:

```
./prepare-naoqi-requirements.sh
```

## Installing NAOv6 development environment

After running the preparation script, the installation one must be run on a
new terminal session. If you wish to remain in the same session, you must reload
your `.bashrc` (`source .bashrc`) to enable the modifications made to enable
PIP2 and its binaries.

```
./install-naov6.sh
```

This script will also prompt for administrative rights, as it needs to install
packages used by the C++ and Python2 SDKs.

### Activating Choregraphe

Choregraphe may prompt for its activation key on its first initialisation. This
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