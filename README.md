# Webitel Stack

## docker daemon

On each node:

    echo -e "[Service]\nLimitMEMLOCK=infinity" | SYSTEMD_EDITOR=tee systemctl edit docker.service
    systemctl daemon-reload
    systemctl restart docker
    echo vm.max_map_count=262144 >> /etc/sysctl.conf
    sysctl -p

On each node (change ethernet device and network range):

    ./bin/mkvxlan.sh

On manager node:

    ./bin/mknet.sh

## portainer

    docker stack deploy --compose-file webitel-portainer-stack.yml swarm

## consul

    docker stack deploy --compose-file webitel-consul-stack.yml consul

## PostgreSQL

    docker node update --label-add database=true node-1
    docker stack deploy --compose-file webitel-postgres-stack.yml sql

## rabbitmq

    docker node update --label-add rabbitmq1=true node-1
    docker node update --label-add rabbitmq2=true node-2
    docker stack deploy --compose-file webitel-rabbitmq-stack.yml amq

HA: https://www.rabbitmq.com/ha.html

## Open Distro for Elasticsearch

    docker node update --label-add elastic=true node-1
    docker node update --label-add elastic=true node-2
    docker stack deploy --compose-file webitel-opendistro-stack.yml esk
