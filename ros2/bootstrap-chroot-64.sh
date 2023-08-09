#!/bin/bash

source './chroot-env-vars.sh'

run_debootstrap "${ARM64_CHROOT}" "${ARM64_ARCH}" "${ARM64_CHROOT_CACHE}" "${DEBOOTSTRAP_SUITE}" "${DEBOOTSTRAP_MIRROR}" "${ARM64_ARCH}"

copy_qemu_user_static "/usr/bin/qemu-arm-static" "./${ARM64_CHROOT}/usr/bin" "${ARM64_ARCH}"

run_on_chroot "${ARM64_CHROOT}" 'root' apt update

create_chrooted_user "${ARM64_CHROOT}" 'softex' 1000 'softex'

# This fixes Git trying to access root's configuration directories
run_on_chroot "${ARM64_CHROOT}" 'root' apt install --yes git
run_on_chroot "${ARM64_CHROOT}" '1000' bash -c "cd /home/${CHROOTED_USER} && env USER=${CHROOTED_USER} HOME=/home/${CHROOTED_USER} git config --global init.defaultBranch main"
run_on_chroot "${ARM64_CHROOT}" '1000' bash -c "cd /home/${CHROOTED_USER} && USER=${CHROOTED_USER} HOME=/home/${CHROOTED_USER} git config --list --show-origin"

# add security repo and update
add_security_repo "${ARM64_CHROOT}" "${DEBOOTSTRAP_SECURITY_MIRROR}" "${DEBOOTSTRAP_SECURITY_SUITE}"
