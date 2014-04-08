#!/usr/bin/env bash

echo ">>> Installing RethinkDB"

# Add PPA to server
sudo add-apt-repository -y ppa:rethinkdb/ppa

# Update
sudo apt-get update

# Install
sudo apt-get install rethinkdb -y --force-yes
