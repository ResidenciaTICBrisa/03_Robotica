#!/bin/bash

source './env-vars.sh'

chmod -v 0755 /usr/lib/qemu/qemu-bridge-helper
rm -v /etc/qemu/bridge.conf

sysctl "net.ipv4.conf.${BRIDGE}.forwarding=0"
sysctl "net.ipv6.conf.${BRIDGE}.forwarding=0"

ip link set "${BRIDGE}" down
ip link delete "${BRIDGE}" type bridge

nft delete table inet "${QEMU_NAT_TABLE}"
nft delete table inet "${QEMU_FILTER_TABLE}"
