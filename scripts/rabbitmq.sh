#!/usr/bin/env bash

echo ">>> Installing RabbitMQ"

sudo apt-get -y install erlang-nox
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc
echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get update
sudo apt-get install -y rabbitmq-server

rabbitmqctl add_user $1 $2
rabbitmqctl set_permissions -p / $1 ".*" ".*" ".*"

sudo apt -f -y autoremove --purge