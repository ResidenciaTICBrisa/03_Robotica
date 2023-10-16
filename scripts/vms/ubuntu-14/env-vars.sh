#!/bin/bash

# [ -z "${VAR}" ] && echo "unset" || echo "set"
[ -z "${SOURCED_ENV_VARS_SH}" ] || exit 0

readonly BIOS_LOCATION="/usr/share/seabios/bios-256k.bin"
readonly IMAGE_LOCATION="ubuntu-14.04-desktop-amd64.iso"
readonly DISK_LOCATION="ubuntu-14.04-vm.qcow2"

readonly DISK_SIZE="50G"

readonly VM_INITIAL_NAME="ubuntu-14.04-nao-first-boot"
readonly VM_NAME="ubuntu-14.04-nao"
readonly IPV4_NETWORK="192.168.3.0/24"
readonly IPV4_DHCP_FIRST_ADDR="192.168.3.220"
readonly P22_FWD="10022"
readonly MACHINE_TYPE="pc-q35-6.2"
readonly MACHINE_CFG="type=${MACHINE_TYPE},accel=kvm"
readonly CPU_MODEL="Haswell-v4"
readonly CPU_NUMBER="4"
readonly MACHINE_MEMORY_SIZE="4G"
readonly DISPLAY_DEVICE="vmware-svga,vgamem_mb=32"
readonly DISPLAY_BACKEND="gtk"

readonly VM_USER="softex"

readonly USB_HOST_BUS=""
readonly USB_HOST_ADDRESS=""
readonly USB_VENDOR_ID=""
readonly USB_PRODUCT_ID=""
readonly USB_FILE="/dev/bus/usb/${USB_HOST_BUS}/${USB_HOST_ADDRESS}"

readonly BRIDGE="qemubr0"
readonly INTERFACE=""
readonly BRIDGE_IP="10.14.1.15/16"
readonly DNSMASQ_IP_START="10.14.1.16"
readonly DNSMASQ_IP_END="10.14.1.254"
readonly DNSMASQ_IP_MASK="255.255.0.0"
readonly VM_MAC="52:54:00:00:04:01"
readonly QEMU_NAT_TABLE="qemu-nat"
readonly QEMU_FILTER_TABLE="qemu-filter"

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

echo "BRIDGE=${BRIDGE:?${UNSET_WARNING}}"
#echo "INTERFACE=${INTERFACE:?${UNSET_WARNING}}"
echo "BRIDGE_IP=${BRIDGE_IP:?${UNSET_WARNING}}"
echo "DNSMASQ_IP_START=${DNSMASQ_IP_START:?${UNSET_WARNING}}"
echo "DNSMASQ_IP_END=${DNSMASQ_IP_END:?${UNSET_WARNING}}"
echo "DNSMASQ_IP_MASK=${DNSMASQ_IP_MASK:?${UNSET_WARNING}}"
echo "VM_MAC=${VM_MAC:?${UNSET_WARNING}}"
echo "QEMU_NAT_TABLE=${QEMU_NAT_TABLE:?${UNSET_WARNING}}"
echo "QEMU_FILTER_TABLE=${QEMU_FILTER_TABLE:?${UNSET_WARNING}}"

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

abort_if_iproute2_not_found() {
	if ! command -v ip >/dev/null; then
		echo "'ip' not found"
		echo "Please install 'iproute2'"
		exit 6
	fi
}

abort_if_nftables_not_found() {
	if ! command -v nft >/dev/null; then
		echo "'nft' not found"
		echo "Please install 'nftables'"
		echo 7
	fi
}

abort_if_interface_not_found() {
	if ! ip link show "${INTERFACE}" >/dev/null; then
		echo "Device ${INTERFACE} does not exist"
		echo 8
	fi
}

readonly SOURCED_ENV_VARS_SH=1
