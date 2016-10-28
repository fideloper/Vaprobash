#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

[[ $PHP_IS_INSTALLED -ne 0 ]] && { printf "!!! PHP is not installed.\n    Installing ØMQ aborted!\n"; exit 0; }

echo ">>> Installing ØMQ"

sudo add-apt-repository -qq pp:chris-lea/zeromq 
sudo apt-get update -qq
sudo apt-get install -qq libtool autoconf automake uuid uuid-dev uuid-runtime build-essential php5-dev pkg-config libzmq3-dbg libzmq3-dev libzmq3

echo "" | sudo pecl install zmq-beta > /dev/null

sudo echo "extension=zmq.so" >> /etc/php5/mods-available/zmq.ini
sudo php5enmod zmq > /dev/null
sudo service php5-fpm restart > /dev/null

