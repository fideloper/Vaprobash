#!/usr/bin/env bash

echo ">>> Installing Laravel"

# Test if Composer is installed
composer --version > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

if [ $COMPOSER_IS_INSTALLED -gt 0 ]; then
    echo "ERROR: Laravel install requires composer"
    exit 1
fi

# Create Laravel
composer create-project --prefer-dist laravel/laravel /vagrant/laravel

# Set new document root on Apache or Nginx
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    # Change default vhost created
    sed -i "s/root \/vagrant/root \/vagrant\/laravel\/public/" /etc/nginx/sites-available/vagrant
fi

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    # Remove apache vhost from default and create a new one
    rm /etc/apache2/sites-enabled/192.168.33.10.xip.io.conf > /dev/null 2>&1
    rm /etc/apache2/sites-available/192.168.33.10.xip.io.conf > /dev/null 2>&1
    vhost -s 192.168.33.10.xip.io -d /vagrant/laravel/public
fi
