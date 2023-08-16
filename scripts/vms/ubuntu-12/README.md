# Maratona Linux Development Scripts

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
- an image from Ubuntu's installation disk version 12.04 named as
`ubuntu-12.04-desktop-amd64.iso` (this can be altered in the `IMAGE_LOCATION`
variable at the `env-vars.sh` script)

## Starting the Virtual Machine up for the first time

The initial images are created by the `reset-*` scripts

```
./reset-main-drive
```

With the drives created, run the initialisation script and install a regular
Ubuntu 12.04 LTS installation:

- Language and keyboard layout: Português Brasileiro
- Erase disk and install Ubuntu
- Timezone: Sao Paulo

```
./first-boot
```

Ubuntu 12.04 is not a supported release anymore. This means that the repository
in the original release has been changed to the old release archive. In order to
fix this, run the following script when the VM is disabled:

```
./update-sources.sh
```

## Installing a newer pip

### Compiling a newer Python 2.7

```
sudo apt-get install build-essential
sudo apt-get build-dep python-dev

wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz
tar -xvf Python-2.7.11.tar.xz

cd Python-2.7.11
./configure --prefix ${HOME}/.local
make -j $(nproc) profile-opt
make install

echo 'export PATH="${HOME}/.local/bin:${PATH}"' >> "${HOME}/.bashrc"
```

### Installing pip

```
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
python get-pip.py
```