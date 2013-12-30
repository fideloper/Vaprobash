#!/usr/bin/env bash

# Install Memcached
sudo apt-get install -y memcached php5-memcached

# Test if php5-fpm or Apache-based PHP
php5-fpm -v 2>&1 >/dev/null
PHPFPM_IS_INSTALLED=$?

apache2 -v 2>&1 >/dev/null
APACHE_IS_INSTALLED=$?

# Restart necessary service
if [ $PHPFPM_IS_INSTALLED -eq 0 ]; then
    sudo service php5-fpm restart
fi

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    sudo service apache2 restart
fi
