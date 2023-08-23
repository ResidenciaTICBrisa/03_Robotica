#!/bin/bash

# [ -z "${VAR}" ] && echo "unset" || echo "set"
[ -z "${SOURCED_ENV_VARS_SH}" ] || exit 0

readonly BIOS_LOCATION="/usr/share/seabios/vgabios-virtio.bin"
readonly IMAGE_LOCATION="ubuntu-12.04-desktop-amd64.iso"
readonly DISK_LOCATION="ubuntu-12.04-vm.qcow2"

readonly DISK_SIZE="50G"

readonly VM_INITIAL_NAME="ubuntu-12.04-nao-first-boot"
readonly VM_NAME="ubuntu-12.04-nao"
readonly IPV4_NETWORK="192.168.3.0/24"
readonly IPV4_DHCP_FIRST_ADDR="192.168.3.220"
readonly P22_FWD="10022"
readonly MACHINE_TYPE="pc-q35-6.2"
readonly MACHINE_CFG="type=${MACHINE_TYPE},accel=kvm"
readonly CPU_MODEL="Nehalem-v2"
readonly CPU_NUMBER="8"
readonly MACHINE_MEMORY_SIZE="4G"
readonly DISPLAY_DEVICE="qxl-vga"
readonly DISPLAY_BACKEND="gtk"

readonly VM_USER="softex"

readonly USB_HOST_BUS=""
readonly USB_HOST_ADDRESS=""

readonly USB_VENDOR_ID=""
readonly USB_PRODUCT_ID=""

readonly UNSET_WARNING="is unset or empty"

echo "BIOS_LOCATION=${BIOS_LOCATION:?${UNSET_WARNING}}"
echo "IMAGE_LOCATION=${IMAGE_LOCATION:?${UNSET_WARNING}}"
echo "DISK_LOCATION=${DISK_LOCATION:?${UNSET_WARNING}}"

echo "DISK_SIZE=${DISK_SIZE:?${UNSET_WARNING}}"

echo "VM_INITIAL_NAME=${VM_INITIAL_NAME:?${UNSET_WARNING}}"
echo "VM_NAME=${VM_NAME:?${UNSET_WARNING}}"

echo "VM_USER=${VM_USER:?${UNSET_WARNING}}"

echo "IPV4_NETWORK=${IPV4_NETWORK:?${UNSET_WARNING}}"
echo "IPV4_DHCP_FIRST_ADDR=${IPV4_DHCP_FIRST_ADDR:?${UNSET_WARNING}}"
echo "P22_FWD=${P22_FWD:?${UNSET_WARNING}}"
echo "MACHINE_TYPE=${MACHINE_TYPE:?${UNSET_WARNING}}"
echo "MACHINE_CFG=${MACHINE_CFG:?${UNSET_WARNING}}"
echo "CPU_MODEL=${CPU_MODEL:?${UNSET_WARNING}}"
echo "CPU_NUMBER=${CPU_NUMBER:?${UNSET_WARNING}}"
echo "MACHINE_MEMORY_SIZE=${MACHINE_MEMORY_SIZE:?${UNSET_WARNING}}"

abort_if_bios_not_found() {
	if [[ ! -e "${BIOS_LOCATION}" ]]; then
		echo "UEFI/BIOS not found on '${BIOS_LOCATION}'"
		echo "Try 'apt install ovmf' or 'apt install seabios'"
		exit 1
	fi
}

abort_if_image_not_found() {
	if [[ ! -e "${IMAGE_LOCATION}" ]]; then
		echo "Installation image not found on '${IMAGE_LOCATION}'"
		exit 2
	fi
}

abort_if_disk_not_found() {
	if [[ ! -e "${DISK_LOCATION}" ]]; then
		echo "Virtual Machine disk not found on '${DISK_LOCATION}'"
		exit 3
	fi
}

readonly SOURCED_ENV_VARS_SH=1
