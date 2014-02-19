#!/usr/bin/env bash

echo ">>> Installing Symfony"

[[ -z "$1" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [ -z "$2" ]; then
    symfony_root_folder="/vagrant/symfony"
else
    symfony_root_folder="$2"
fi

# The host ip is same as guest ip with last octet equal to 1
host_ip=`echo $1 | sed 's/\.[0-9]*$/.1/'`

# Test if Composer is installed
composer --version > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

if [ $COMPOSER_IS_INSTALLED -gt 0 ]; then
    echo "ERROR: Symfony install requires composer"
    exit 1
fi

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

# Test if Apache or Nginx is installed
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Create Symfony folder if needed
if [ ! -d $symfony_root_folder ]; then
    mkdir -p $symfony_root_folder
fi

if [ ! -f "$symfony_root_folder/composer.json" ]; then
    # Create Symfony
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer create-project --prefer-dist symfony/framework-standard-edition $symfony_root_folder
    else
        composer create-project --prefer-dist symfony/framework-standard-edition $symfony_root_folder
    fi
else
    # Go to vagrant folder
    cd $symfony_root_folder

    # Install Symfony
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer install --prefer-dist
    else
        composer install --prefer-dist
    fi

    # Go to the previous folder
    cd -
fi

sudo chmod -R 775 $symfony_root_folder/app/cache
sudo chmod -R 775 $symfony_root_folder/app/logs
sudo chmod -R 775 $symfony_root_folder/app/console

sed -i "s/'127.0.0.1',/'127.0.0.1', '$host_ip',/" $symfony_root_folder/web/app_dev.php
sed -i "s/'127.0.0.1',/'127.0.0.1', '$host_ip',/" $symfony_root_folder/web/config.php

if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    nginx_root=$(echo "$symfony_root_folder/web" | sed 's/\//\\\//g')

    # Change default vhost created
    sed -i "s/root \/vagrant/root $nginx_root/" /etc/nginx/sites-available/vagrant
    sudo service nginx reload
fi

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    # Remove apache vhost from default and create a new one
    rm /etc/apache2/sites-enabled/$1.xip.io.conf > /dev/null 2>&1
    rm /etc/apache2/sites-available/$1.xip.io.conf > /dev/null 2>&1
    vhost -s $1.xip.io -d "$symfony_root_folder/web"
    sudo service apache2 reload
fi
