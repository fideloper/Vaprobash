#!/usr/bin/env bash

echo ">>> Installing Laravel"

[[ -z "$1" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

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

if [ ! -f /vagrant/composer.json ]; then
    # Create Laravel
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer create-project --prefer-dist laravel/laravel /vagrant/laravel
    else
        composer create-project --prefer-dist laravel/laravel /vagrant/laravel
    fi

    # Root of Apache or Nginx
    webdocroot=/vagrant/laravel/public
else
    # Go to vagrant folder
    cd /vagrant

    # Install Laravel
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer install --prefer-dist
    else
        composer install --prefer-dist
    fi

    # Go to the previous folder
    cd -

    # Root of Apache or Nginx
    webdocroot=/vagrant/public
fi

if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    # Change default vhost created
    sed -i "s/root \/vagrant/root $webdocroot" /etc/nginx/sites-available/vagrant
    sudo service nginx reload
fi

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    # Remove apache vhost from default and create a new one
    rm /etc/apache2/sites-enabled/$1.xip.io.conf > /dev/null 2>&1
    rm /etc/apache2/sites-available/$1.xip.io.conf > /dev/null 2>&1
    vhost -s $1.xip.io -d $webdocroot
    sudo service apache2 reload
fi
