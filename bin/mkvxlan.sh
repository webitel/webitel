#!/bin/bash
export PARENTDEV=eno1

ip link del wbr0
ip link add wbr0 link $PARENTDEV type macvlan mode bridge
ip addr add 192.168.83.8/32 dev wbr0
ip link set wbr0 up
ip route add 192.168.83.8/29 dev wbr0

docker network create --config-only \
        --subnet 192.168.83.0/24 \
        --gateway 192.168.83.1 \
        --ip-range 192.168.83.8/29 \
        --aux-address 'node1=192.168.83.8' \
        -o parent=$PARENTDEV wnet_macvlan

exit 0
