#!/usr/bin/env bash

echo ">>> Installing MySQL Server 5.6"

[[ -z "$1" ]] && { echo "!!! MySQL root password not set. Check the Vagrant file."; exit 1; }

# Add repo for latest MySQL
sudo add-apt-repository -y ppa:ondrej/mysql-5.6

# Update Again
sudo apt-get update

# Install MySQL without password prompt
# Set username and password to 'root'
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"

# Install MySQL Server
sudo apt-get install -y mysql-server-5.6
