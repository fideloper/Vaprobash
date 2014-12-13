#!/usr/bin/env bash

echo ">>> Installing RethinkDB"

# Add PPA to server
sudo add-apt-repository -y ppa:rethinkdb/ppa

# Update
sudo apt-get update

# Install
# -qq implies -y --force-yes
sudo apt-get install -qq rethinkdb
