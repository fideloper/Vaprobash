#!/usr/bin/env bash

echo ">>> Installing MySQL Server"

mysql_root_password:=root

# Install MySQL without password prompt
# Set username and password to 'root'
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password:"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_password"

# Install MySQL Server
sudo apt-get install -y mysql-server
