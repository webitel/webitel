#!/bin/bash
export PARENTDEV=enp2s0

#docker swarm join --token SWMTKN-1-2c8w21bqhneoajrfpw1600wvclvv75c56ywwphry001kzwg9vr-7hkucqz5v9v9el2x665awcsro 192.168.177.199:2377
docker network create --config-only \
	--subnet 192.168.177.0/24 \
	--gateway 192.168.177.1 \
	--ip-range 192.168.177.8/29 \
	--aux-address 'host=192.168.177.9' \
	-o parent=$PARENTDEV wnet_macvlan
docker network create -d macvlan --scope swarm --config-from wnet_macvlan wnet_macvlan_swarm
docker stack deploy --compose-file webitel-portainer-stack.yml swarm

ip link add wbr0 link $PARENTDEV type macvlan mode bridge
ip addr add 192.168.177.9/32 dev wbr0
ip link set wbr0 up
ip route add 192.168.177.8/29 dev wbr0

exit 0
