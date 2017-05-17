#!/usr/bin/env bash

echo ">>> Installing Silex"

# Test if PHP is installed
php -v > /dev/null 2>&1 || { printf "!!! PHP is not installed.\n    Installing Silex aborted!\n"; exit 0; }

# Test if Composer is installed
composer -v > /dev/null 2>&1 || { printf "!!! Composer is not installed.\n    Installing Silex aborted!\n"; exit 0; }

# Test if Server IP is set in Vagrantfile
[[ -z "$1" ]] && { printf "!!! IP address not set. Check the Vagrantfile.\n    Installing Silex aborted!\n"; exit 0; }

# Check if Silex root is set. If not set use default
if [ -z "$2" ]; then
    silex_root_folder="/vagrant/silex"
else
    silex_root_folder="$2"
fi

silex_public_folder="$silex_root_folder/web"

# The host ip is same as guest ip with last octet equal to 1
host_ip=`echo $1 | sed 's/\.[0-9]*$/.1/'`

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

# Test if Apache or Nginx is installed
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Create Silex folder if needed
if [ ! -d $silex_root_folder ]; then
    mkdir -p $silex_root_folder
fi

if [ ! -f "$silex_root_folder/composer.json" ]; then
    # Create Silex
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer create-project --prefer-dist fabpot/silex-skeleton $silex_root_folder
    else
        composer create-project --prefer-dist fabpot/silex-skeleton $silex_root_folder
    fi
else
    # Go to vagrant folder
    cd $silex_root_folder

    # Install Silex
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer install --prefer-dist
    else
        composer install --prefer-dist
    fi

    # Go to the previous folder
    cd -
fi

sudo chmod -R 775 $silex_root_folder/var/cache
sudo chmod -R 775 $silex_root_folder/var/logs

sed -i "s/('127.0.0.1', 'fe80::1'/('127.0.0.1', '$host_ip', 'fe80::1'/" $silex_public_folder/index_dev.php

if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    # Change default vhost created
    sudo sed -i "s@root /vagrant@root $silex_public_folder@" /etc/nginx/sites-available/vagrant
    sudo service nginx reload
fi

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    # Find and replace to find public_folder and replace with laravel_public_folder
    # Change DocumentRoot
    # Change ProxyPassMatch fcgi path
    # Change <Directory ...> path
    sudo sed -i "s@$3@$silex_public_folder@" /etc/apache2/sites-available/$1.xip.io.conf

    sudo service apache2 reload
fi