#!/usr/bin/env bash

echo ">>> Installing MongoDB"

# Get key and add to sources
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

# Make MongoDB connectable from outside world without SSH tunnel
if [ $2 == "3.0" ]; then
  echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
else
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
fi


# Update
sudo apt-get update

# Install MongoDB
# -qq implies -y --force-yes
sudo apt-get install -qq mongodb-org pkg-config libssl-dev

# Make MongoDB connectable from outside world without SSH tunnel
if [ $1 == "true" ]; then
    # enable remote access
    # setting the mongodb bind_ip to allow connections from everywhere
    sed -i "s/bind_ip = .*/bind_ip = 0.0.0.0/" /etc/mongod.conf
fi

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?
PHP_VERSION=0 && [[ $PHP_IS_INSTALLED -eq 0 ]] && PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION;')
PHP_PATH="/etc/php5" && [[ $PHP_VERSION -eq 7 ]] && PHP_PATH="/etc/php/7.0"

if [ $PHP_IS_INSTALLED -eq 0 ]; then
    # install dependencies
    if [[ PHP_VERSION -eq 7 ]]; then
        sudo apt-get -y install php-pear php7.0-dev
    else    
        sudo apt-get -y install php-pear php5-dev
    fi

    # install php extension
    echo "no" > answers.txt
    sudo pecl install mongodb < answers.txt
    rm answers.txt

    # add extension file and restart service
    echo 'extension=mongodb.so' | sudo tee "${PHP_PATH}"/mods-available/mongo.ini

    ln -s "${PHP_PATH}"/mods-available/mongo.ini "${PHP_PATH}"/fpm/conf.d/mongo.ini
    ln -s "${PHP_PATH}"/mods-available/mongo.ini "${PHP_PATH}"/cli/conf.d/mongo.ini
    
    if [[ PHP_VERSION -eq 7 ]]; then
        sudo service php7.0-fpm restart
    else
        sudo service php5-fpm restart
    fi
fi
