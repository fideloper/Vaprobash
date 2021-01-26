#!/usr/bin/env bash

# Install Memcached
# -qq implies -y --force-yes
sudo apt-get install -qq memcached

sudo apt -f -y autoremove --purge