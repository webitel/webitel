#!/bin/bash
export PARENTDEV=eno1

docker stack deploy --compose-file webitel-portainer-stack.yml swarm

#ip link del wbr0
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
docker network create -d macvlan --scope swarm --config-from wnet_macvlan wnet_macvlan_swarm

docker network create -d overlay --subnet=10.11.0.0/24 --attachable wtel_vlan

#
#docker stack deploy --compose-file webitel-consul-stack.yml swarm
#
#docker node update --label-add rabbitmq1=true node-1
#docker node update --label-add rabbitmq2=true node-2
#docker stack deploy --compose-file webitel-rabbitmq-stack.yml swarm
#https://www.rabbitmq.com/ha.html
#


exit 0
