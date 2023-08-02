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
2. Run, with administrator priviledges,the script `install-ros-32.sh` or
`install-ros-64.sh`, depending on the Operating System installed on your
Single Board Computer.
3. Authorise the operations inside the *chrooted* environment using the
`CHROOTED_USER`'s password defined in the `chroot-env-vars.sh` script.
4. ROS will be installed on the `CHROOTED_USER`'s home directory. Depending on
your operating system, you may need to install `ros-dev-tools` or a similar
package.