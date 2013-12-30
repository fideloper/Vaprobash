#!/usr/bin/env bash

echo ">>> Installing MySQL Server"

# Install MySQL without password prompt
# Set username and password to 'root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Install MySQL Server
sudo apt-get install -y mysql-server
