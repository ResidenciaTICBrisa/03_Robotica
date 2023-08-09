#!/bin/bash

source './chroot-env-vars.sh'

readonly INSTALLATION_SCRIPT='ubuntu-install-ros2-humble-base.sh'

cp "${INSTALLATION_SCRIPT}" "${ARM64_CHROOT}/home/${CHROOTED_USER}"
chmod 755 "${ARM64_CHROOT}/home/${CHROOTED_USER}/${INSTALLATION_SCRIPT}"
run_on_chroot "${ARM64_CHROOT}" '1000' bash -c "cd /home/${CHROOTED_USER} && USER=${CHROOTED_USER} HOME=/home/${CHROOTED_USER} ./${INSTALLATION_SCRIPT}"
