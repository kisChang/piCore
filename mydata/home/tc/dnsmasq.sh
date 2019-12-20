#!/bin/sh

# user variables
lan_if=wlan0
ip_stem=192.168.10

# set lan_if ip address
ifconfig $lan_if $ip_stem.1

# create dnsmasq.conf
echo "listen-address=$ip_stem.1
address=/#/$ip_stem.1
dhcp-range=$ip_stem.100,$ip_stem.200,255.255.255.0,24h
dhcp-option-force=option:router,$ip_stem.1
dhcp-option-force=option:dns-server,$ip_stem.1
dhcp-option-force=option:mtu,1500" >/tmp/dnsmasq.conf

# need misc dir
if [ ! -f /var/lib/misc ]; then
  mkdir /var/lib/misc
fi

# start dnsmasq
dnsmasq -C /tmp/dnsmasq.conf