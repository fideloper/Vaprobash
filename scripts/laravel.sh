#!/usr/bin/env bash

echo ">>> Installing Laravel"

[[ -z "$1" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [ -z "$2" ]; then
    laravel_root_folder="/vagrant/laravel"
else
    laravel_root_folder="$2"
fi

# Test if Composer is installed
composer --version > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

if [ $COMPOSER_IS_INSTALLED -gt 0 ]; then
    echo "ERROR: Laravel install requires composer"
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

# Create Laravel folder if needed
if [ ! -d $laravel_root_folder ]; then
    mkdir -p $laravel_root_folder
fi

if [ ! -f "$laravel_root_folder/composer.json" ]; then
    # Create Laravel
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer create-project --prefer-dist laravel/laravel $laravel_root_folder
    else
        composer create-project --prefer-dist laravel/laravel $laravel_root_folder
    fi
else
    # Go to vagrant folder
    cd $laravel_root_folder

    # Install Laravel
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer install --prefer-dist --dev --optimize-autoloader
    else
        composer install --prefer-dist --dev --optimize-autoloader
    fi

    # Go to the previous folder
    cd -
fi

if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    nginx_root=$(echo "$laravel_root_folder/public" | sed 's/\//\\\//g')

    # Change default vhost created
    sed -i "s/root \/vagrant/root $nginx_root/" /etc/nginx/sites-available/vagrant
    sudo service nginx reload
fi

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    # Remove apache vhost from default and create a new one
    rm /etc/apache2/sites-enabled/$1.xip.io.conf > /dev/null 2>&1
    rm /etc/apache2/sites-available/$1.xip.io.conf > /dev/null 2>&1
    vhost -s $1.xip.io -d "$laravel_root_folder/public"
    sudo service apache2 reload
fi
