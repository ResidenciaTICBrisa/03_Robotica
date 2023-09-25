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

nft add table inet qemu-filter
nft add chain inet qemu-filter input '{ type filter hook input priority filter; }'
nft add chain inet qemu-filter output '{ type filter hook output priority filter; }'
nft add chain inet qemu-filter forward '{ type filter hook forward priority filter; policy drop; }'
nft add rule inet qemu-filter forward iifname "${BRIDGE}" oifname "${INTERFACE}" log accept
nft add rule inet qemu-filter forward ct state related,established log accept

nft add table inet qemu-nat
nft add chain inet qemu-nat postrouting '{ type nat hook postrouting priority srcnat; policy accept; }'
nft add chain inet qemu-nat prerouting '{ type nat hook prerouting priority dstnat; policy accept; }'
nft add chain inet qemu-nat output '{ type nat hook output priority -100; policy accept; }'
nft add rule inet qemu-nat postrouting oifname "${INTERFACE}" log masquerade

dnsmasq --interface="${BRIDGE}" --bind-interfaces --dhcp-range="${DNSMASQ_IP_START},${DNSMASQ_IP_END},${DNSMASQ_IP_MASK}" --no-daemon
