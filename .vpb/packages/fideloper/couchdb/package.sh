#!/usr/bin/env bash

echo ">>> Installing CouchDB"

# Install CouchDB
sudo apt-get install couchdb -y

# Make Futon Available
sudo sed -i 's/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/' /etc/couchdb/local.ini