#!/bin/bash

# [ -z "${VAR}" ] && echo "unset" || echo "set"
[ -z "${SOURCED_ENV_VARS_SH}" ] || exit 0

readonly BIOS_LOCATION="/usr/share/OVMF/OVMF_CODE.fd"
readonly IMAGE_LOCATION="ubuntu-16.04-desktop-amd64.iso"
readonly DISK_LOCATION="ubuntu-16.04-vm.qcow2"

readonly DISK_SIZE="50G"

readonly VM_INITIAL_NAME="ubuntu-16.04-nao-first-boot"
readonly VM_NAME="ubuntu-16.04-nao"
readonly IPV4_NETWORK="192.168.3.0/24"
readonly IPV4_DHCP_FIRST_ADDR="192.168.3.220"
readonly P22_FWD="10022"
readonly MACHINE_TYPE="pc-q35-6.2"
readonly MACHINE_CFG="type=${MACHINE_TYPE},accel=kvm"
readonly CPU_MODEL="Haswell-v4"
readonly CPU_NUMBER="4"
readonly MACHINE_MEMORY_SIZE="4G"
readonly DISPLAY_DEVICE="virtio-vga-gl"
readonly DISPLAY_BACKEND="gtk,gl=on"

readonly VM_USER="softex"

readonly USB_HOST_BUS=""
readonly USB_HOST_ADDRESS=""
readonly USB_VENDOR_ID=""
readonly USB_PRODUCT_ID=""
readonly USB_FILE="/dev/bus/usb/${USB_HOST_BUS}/${USB_HOST_ADDRESS}"

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

abort_if_usb_not_found() {
	echo "USB_HOST_BUS=${USB_HOST_BUS:?${UNSET_WARNING}}"
	echo "USB_HOST_ADDRESS=${USB_HOST_ADDRESS:?${UNSET_WARNING}}"

	if [[ ! -e "${USB_FILE}" ]]; then
		echo "USB device not found at '${USB_FILE}'"
		exit 4
	fi
}

abort_if_usb_misconfigured() {
	echo "USB_HOST_BUS=${USB_HOST_BUS:?${UNSET_WARNING}}"
	echo "USB_HOST_ADDRESS=${USB_HOST_ADDRESS:?${UNSET_WARNING}}"
	echo "USB_VENDOR_ID=${USB_VENDOR_ID:?${UNSET_WARNING}}"
	echo "USB_PRODUCT_ID=${USB_PRODUCT_ID:?${UNSET_WARNING}}"

	abort_if_usb_not_found

	lsusb \
		-s "${USB_HOST_BUS}:${USB_HOST_ADDRESS}" \
		-d "${USB_VENDOR_ID}:${USB_PRODUCT_ID}" \
		>/dev/null
	local status=$?

	if [[ "$status" != 0 ]]; then
		echo "Mismatched vendor or product id"
		exit 5
	fi
}

readonly SOURCED_ENV_VARS_SH=1
