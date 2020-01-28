# Webitel Stack

## docker swarm

Install docker swarm. On each node execute:

    echo -e "[Service]\nLimitMEMLOCK=infinity" | SYSTEMD_EDITOR=tee systemctl edit docker.service
    systemctl daemon-reload
    systemctl restart docker
    echo vm.max_map_count=262144 >> /etc/sysctl.conf
    sysctl -p

On each node (change ethernet device and network range):

    ./bin/mkvxlan.sh

On the manager node:

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

## rtpengine

Debian 10 / buster

    apt-get install -qqy --no-install-recommends gnupg2 wget lsb-release
    echo "deb http://deb.webitel.com/debian `lsb_release -sc` main" > /etc/apt/sources.list.d/webitel.list
    wget -qO - http://deb.webitel.com/archive.key | sudo apt-key add -
    apt-get update
    apt-get install -qqy --no-install-recommends ngcp-rtpengine

This only needs to be one once after system (re-) boot

    modprobe xt_RTPENGINE
    iptables -I INPUT -p udp -j RTPENGINE --id 0
    ip6tables -I INPUT -p udp -j RTPENGINE --id 0

Ensure that the table we want to use doesn't exist - usually needed after a daemon
Restart, otherwise will error

    echo 'del 0' > /proc/rtpengine/control

Edit config file `/etc/rtpengine/rtpengine.conf` and start rtpengine:

    systemctl enable ngcp-rtpengine-daemon
    systemctl start ngcp-rtpengine-daemon

