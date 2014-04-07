#!/usr/bin/env bash

echo ">>> Installing MongoDB"

# Get key and add to sources
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

# Update
sudo apt-get update

# Install MongoDB
sudo apt-get -y install mongodb-10gen

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

if [[ $PHP_IS_INSTALLED -eq 0 ]]; then
    # install dependencies
    sudo apt-get -y install php-pear php5-dev

    # install php extencion
    sudo pecl install mongo

    # add extencion file and restart service
    echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini

    if ps ax | grep -v grep | grep apache2 > /dev/null; then
        ln -s /etc/php5/mods-available/mongo.ini /etc/php5/apache2/conf.d/mongo.ini
        # echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini
        sudo service apache2 restart
    fi

    if ps ax | grep -v grep | grep php-fpm > /dev/null; then
        ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/mongo.ini
        # echo 'extension=mongo.so' | sudo tee /etc/php5/fpm/conf.d/mongo.ini
        sudo service php5-fpm restart
    fi
fi