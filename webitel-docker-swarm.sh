#!/bin/bash
export PARENTDEV=enp2s0

ip link add wbr0 link $PARENTDEV type macvlan mode bridge
ip addr add 192.168.177.8/32 dev wbr0
ip link set wbr0 up
ip route add 192.168.177.8/29 dev wbr0
docker network create --config-only \
        --subnet 192.168.177.0/24 \
        --gateway 192.168.177.1 \
        --ip-range 192.168.177.8/29 \
        --aux-address 'host=192.168.177.8' \
        -o parent=$PARENTDEV wnet_macvlan
docker network create -d macvlan --scope swarm --config-from wnet_macvlan wnet_macvlan_swarm

docker network create -d overlay --subnet=10.11.0.0/24 wtel_vlan

docker stack deploy --compose-file webitel-portainer-stack.yml swarm

exit 0
