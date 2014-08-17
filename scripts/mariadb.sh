#!/usr/bin/env bash

echo ">>> Installing MariaDB"

[[ -z $1 ]] && { echo "!!! MariaDB root password not set. Check the Vagrant file."; exit 1; }

if [[ -z $5 ]]; then
    github_url="https://raw.githubusercontent.com/fideloper/Vaprobash/master"
else
    github_url="$5"
fi

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
# -qq implies -y --force-yes
sudo apt-get install -qq mariadb-server

# Installing mysql_helper script
curl --silent -L $github_url/helpers/mysql_helper.sh > mysql_helper
sudo chmod guo+x mysql_helper
sudo mv mysql_helper /usr/local/bin

# Make MySQL connectable from outside world without SSH tunnel
if [ $2 == "true" ]; then
    echo ">>> Provision remote access to MySQL"
    mysql_helper -u root -p $1 enable-remote
fi

if [ ! -z "$3" ]; then
    echo ">>> Provision MySQL database"
    mysql_helper -u root -p $1 -d $3 create-database
fi

if [ ! -z "$4" ]; then
    echo ">>> Provision import of MySQL database"
    mysql_helper -u root -p $1 -d $3 -i $4 import-database
fi
