#!/usr/bin/env bash

echo ">>> Installing Supervisord"

# Supervisord
# -qq implies -y --force-yes
sudo apt-get install -qq supervisor

sudo apt -f -y autoremove --purge
