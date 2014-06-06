#!/usr/bin/env bash

echo ">>> Installing MySQL Server $2"

[[ -z "$1" ]] && { echo "!!! MySQL root password not set. Check the Vagrant file."; exit 1; }

mysql_package=mysql-server

if [ $2 == "5.6" ]; then
    # Add repo for MySQL 5.6
	sudo add-apt-repository -y ppa:ondrej/mysql-5.6

	# Update Again
	sudo apt-get update

	# Change package
	mysql_package=mysql-server-5.6
fi

# Install MySQL without password prompt
# Set username and password to 'root'
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"

# Install MySQL Server
sudo apt-get install -y --force-yes $mysql_package

# Disable case sensitivity
shopt -s nocasematch

# Make MySQL connectable from outside world without SSH tunnel
if [[ $3 =~ true ]]; then
    # Enable remote access
    # Setting the mysql bind-address to allow connections from everywhere
    sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

    sudo mysql --user="root" --password="$1" -e "GRAND ALL ON *.* TO 'root'@'%' IDENTIFIED BT '$1' WITH GRANT OPTION;"
    sudo mysql --user="root" --password="$1" -e "FLUSH PRIVILEGES;"

    service mysql restart
fi

# Enable case sensitivity
shopt -u nocasematch
