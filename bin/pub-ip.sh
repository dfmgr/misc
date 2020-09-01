#!/usr/bin/env bash

IP=$(curl -4 -s http://ifconfig.co/ip)

if pgrep -x openvpn > /dev/null; then
    echo VPN: $IP
else
    echo $IP
fi
