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
- an image [1][1] from Ubuntu's installation disk version 12.04 named as
`ubuntu-12.04-desktop-amd64.iso` (this can be altered in the `IMAGE_LOCATION`
variable at the `env-vars.sh` script)

[1]: https://old-releases.ubuntu.com/releases/precise/ubuntu-12.04.5-desktop-amd64.iso

### Creating the VM and preparing to compile NAOqi for NAOv4

The user must run in their host machine the scripts inside this repository in
the following order:

1. `reset-main-drive.sh`
2. `first-boot.sh`

After installing Ubuntu 12.04 in their virtual machine, the following scripts
must be executed in their host machine:

1. `update-sources.sh`
2. `inject-home.sh`

Finally, inside the virtual machine, also known as the guest machine, the user
must run the `prepare-naoqi-requirements.sh` script to compile Python 2.7.11
and install Pip 20.3.4.

## Starting the Virtual Machine up for the first time

The initial images are created by the `reset-*` scripts

```
./reset-main-drive.sh
```

With the drives created, run the initialisation script and install a regular
Ubuntu 12.04 LTS installation:

- Language and keyboard layout: Português Brasileiro
- Erase disk and install Ubuntu
- Timezone: Sao Paulo
- User: softex

```
./first-boot.sh
```

## Running the VM

Ubuntu 12.04 is not a supported release anymore. This means that the repository
in the original release has been changed to the old release archive. In order to
fix this, run the following script when the VM is disabled:

```
./update-sources.sh
```

## Preparing to install NAOqi for NAOv4

Ubuntu 12.04 has an old version of Python 2.7. It lacks support to download data
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