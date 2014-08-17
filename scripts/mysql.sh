#!/usr/bin/env bash

echo ">>> Installing MySQL Server $2"

[[ -z "$1" ]] && { echo "!!! MySQL root password not set. Check the Vagrant file."; exit 1; }

if [[ -z $6 ]]; then
    github_url="https://raw.githubusercontent.com/fideloper/Vaprobash/master"
else
    github_url="$6"
fi

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
# -qq implies -y --force-yes
sudo apt-get install -qq $mysql_package

# Installing mysql_helper script
curl --silent -L $github_url/helpers/mysql_helper.sh > mysql_helper
sudo chmod guo+x mysql_helper
sudo mv mysql_helper /usr/local/bin

# Make MySQL connectable from outside world without SSH tunnel
if [ $3 == "true" ]; then
    echo ">>> Provision remote access to MySQL"
    mysql_helper -u root -p $1 -v $2 enable-remote
fi

if [ ! -z "$4" ]; then
    echo ">>> Provision MySQL database"
    mysql_helper -u root -p $1 -d $4 create-database
fi

if [ ! -z "$5" ]; then
    echo ">>> Provision import of MySQL database"
    mysql_helper -u root -p $1 -d $4 -i $5 import-database
fi
