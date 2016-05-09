#!/usr/bin/env bash

echo ">>> Installing RethinkDB"

# update source list
source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list

# add key
wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add -

# Update
sudo apt-get update

# Install
sudo apt-get install -qq rethinkdb
