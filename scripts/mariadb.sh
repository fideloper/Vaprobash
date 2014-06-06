#!/usr/bin/env bash

echo ">>> Installing MariaDB"

[[ -z $1 ]] && { echo "!!! MariaDB root password not set. Check the Vagrant file."; exit 1; }

# default version
MARIADB_VERSION='10.0'

# Import repo key
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db

# Add repo for MariaDB
sudo add-apt-repository -y "deb http://mirrors.syringanetworks.net/mariadb/repo/10.0/ubuntu trusty main"

# Update
sudo apt-get update

# Install MariaDB without password prompt
# Set username to 'root' and password to 'mariadb_root_password' (see Vagrantfile)
sudo debconf-set-selections <<< "maria-db-$MARIADB_VERSION mysql-server/root_password password $1"
sudo debconf-set-selections <<< "maria-db-$MARIADB_VERSION mysql-server/root_password_again password $1"

# Install MariaDB
sudo apt-get install -y --force-yes mariadb-server

# Disable case sensitivity
shopt -s nocasematch

# Make Maria connectable from outside world without SSH tunnel
if [[ $2 =~ true ]]; then
    # Enable remote access
    # Setting the mysql bind-address to allow connections from everywhere
    sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

    sudo mysql --user="root" --password="$1" -e "GRAND ALL ON *.* TO 'root'@'%' IDENTIFIED BT '$1' WITH GRANT OPTION;"
    sudo mysql --user="root" --password="$1" -e "FLUSH PRIVILEGES;"

    service mysql restart
fi

# Enable case sensitivity
shopt -u nocasematch
