#!/usr/bin/env bash

echo ">>> Installing RabbitMQ"

apt-get -y install erlang-nox
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc
echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
apt-get update
apt-get install -y rabbitmq-server

rabbitmqctl add_user $1 $2
rabbitmqctl set_permissions -p / $1 ".*" ".*" ".*"
