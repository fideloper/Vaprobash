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

if [ $PHP_IS_INSTALLED -eq 0 ]; then
    # install dependencies
    sudo apt-get -y install php-pear php5-dev

    # install php extencion
    echo "no" > answers.txt
    sudo pecl install mongo < answers.txt
    rm answers.txt

    # Find php version
    regex="PHP [0-9][.][0-9][.][0-9][0-9]"
    incoming_string=$(php -v | grep 'PHP ' -m 1)

    if [[ $incoming_string =~ $regex ]]; then
        php_version=${BASH_REMATCH[0]}
    fi

    # Add extension file and restart service
    if [[ $php_version == "PHP 5.3.10" ]]; then
        echo "matched " $php_version
        echo 'extension=mongo.so' | sudo tee /etc/php5/conf.d/mongo.ini
    else
        echo "matched " $php_version
        echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini

        ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/mongo.ini
        ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/mongo.ini
    fi

    sudo service php5-fpm restart

fi
