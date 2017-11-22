#!/usr/bin/env bash

echo ">>> Installing Symfony"

# Test if PHP is installed
php -v > /dev/null 2>&1 || { printf "!!! PHP is not installed.\n    Installing Symfony aborted!\n"; exit 0; }

# Test if Composer is installed
composer -v > /dev/null 2>&1 || { printf "!!! Composer is not installed.\n    Installing Symfony aborted!\n"; exit 0; }

# Test if Server IP is set in Vagrantfile
[[ -z "$1" ]] && { printf "!!! IP address not set. Check the Vagrantfile.\n    Installing Symfony aborted!\n"; exit 0; }

# Check if Symfony root is set. If not set use default
if [ -z "$3" ]; then
    symfony_root_folder="/var/www/symfony-test"
else
    symfony_root_folder="$3"
fi

symfony_public_folder="$symfony_root_folder/web"

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
    # Go to ubuntu folder
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

sed -i "s/('127.0.0.1', 'fe80::1'/('127.0.0.1', '$server_ip', 'fe80::1'/" $symfony_public_folder/app_dev.php
sed -i "s/'127.0.0.1',$/'127.0.0.1', '$server_ip',/" $symfony_public_folder/config.php

if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    # Change default vhost created
    sudo sed -i "s@root /ubuntu@root $symfony_public_folder@" /etc/nginx/sites-available/ubuntu
    sudo service nginx reload
fi

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
	
    sudo vhost -s $symfony_server_name -a $symfony_alias -d $symfony_public_folder

    sudo service apache2 restart
fi
