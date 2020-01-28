# Webitel Stack

## docker daemon

    echo -e "[Service]\nLimitMEMLOCK=infinity" | SYSTEMD_EDITOR=tee systemctl edit docker.service
    systemctl daemon-reload
    systemctl restart docker

## portainer

    docker stack deploy --compose-file webitel-portainer-stack.yml swarm

## consul

    docker stack deploy --compose-file webitel-consul-stack.yml swarm

## rabbitmq

    docker node update --label-add rabbitmq1=true node-1
    docker node update --label-add rabbitmq2=true node-2
    docker stack deploy --compose-file webitel-rabbitmq-stack.yml swarm

HA: https://www.rabbitmq.com/ha.html

## Open Distro for Elasticsearch

    echo vm.max_map_count=262144 >> /etc/sysctl.conf
    sysctl -p
    docker node update --label-add elastic=true node-1
    docker node update --label-add elastic=true node-2
