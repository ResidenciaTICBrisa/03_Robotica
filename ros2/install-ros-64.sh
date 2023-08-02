#!/bin/bash

source './chroot-env-vars.sh'

cp install-ros2-humble.sh "${ARM64_CHROOT}/home/${CHROOTED_USER}"
chmod 755 "${ARM64_CHROOT}/home/${CHROOTED_USER}/install-ros2-humble.sh"
run_on_chroot "${ARM64_CHROOT}" '1000' bash -c "cd /home/${CHROOTED_USER} && USER=${CHROOTED_USER} HOME=/home/${CHROOTED_USER} ./install-ros2-humble.sh"
