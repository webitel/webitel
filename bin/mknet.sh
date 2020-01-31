#!/bin/bash

docker network create -d macvlan --scope swarm --config-from wnet_macvlan wnet_macvlan_swarm
docker network create -d overlay --attachable wtel_vlan

exit 0
