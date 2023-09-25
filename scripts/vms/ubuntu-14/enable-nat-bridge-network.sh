#!/bin/bash

source './env-vars.sh'

chmod -v 4755 /usr/lib/qemu/qemu-bridge-helper
printf 'allow %s\n' "${BRIDGE}" > /etc/qemu/bridge.conf
chmod -v 0644 /etc/qemu/bridge.conf

ip link add "${BRIDGE}" type bridge
ip link set "${BRIDGE}" up
# Must be in a different network than your current one
ip address add "${BRIDGE_IP}" dev "${BRIDGE}"

sysctl "net.ipv4.conf.${BRIDGE}.forwarding=1"
sysctl "net.ipv6.conf.${BRIDGE}.forwarding=1"

nft add table inet "${QEMU_FILTER_TABLE}"
nft add chain inet "${QEMU_FILTER_TABLE}" input '{ type filter hook input priority filter; }'
nft add chain inet "${QEMU_FILTER_TABLE}" output '{ type filter hook output priority filter; }'
nft add chain inet "${QEMU_FILTER_TABLE}" forward '{ type filter hook forward priority filter; policy drop; }'
nft add rule inet "${QEMU_FILTER_TABLE}" forward iifname "${BRIDGE}" oifname "${INTERFACE}" log accept
nft add rule inet "${QEMU_FILTER_TABLE}" forward ct state related,established log accept

nft add table inet "${QEMU_NAT_TABLE}"
nft add chain inet "${QEMU_NAT_TABLE}" postrouting '{ type nat hook postrouting priority srcnat; policy accept; }'
nft add chain inet "${QEMU_NAT_TABLE}" prerouting '{ type nat hook prerouting priority dstnat; policy accept; }'
nft add chain inet "${QEMU_NAT_TABLE}" output '{ type nat hook output priority -100; policy accept; }'
nft add rule inet "${QEMU_NAT_TABLE}" postrouting oifname "${INTERFACE}" log masquerade

dnsmasq --interface="${BRIDGE}" --bind-interfaces --dhcp-range="${DNSMASQ_IP_START},${DNSMASQ_IP_END},${DNSMASQ_IP_MASK}" --no-daemon
