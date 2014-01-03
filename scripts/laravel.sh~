#!/usr/bin/env bash

LARAVEL_APP=/usr/local/bin/laravel

echo ">>> Installing Laravel"

# Check if all needed PHP 5 components are installed
PHP5_INSTALLED=`apt-cache policy php5 | grep Installed | grep -v "(none)"`
PHP5_CURL_INSTALLED=`apt-cache policy php5-curl | grep Installed | grep -v "(none)"`
PHP5_MCRYPT_INSTALLED=`apt-cache policy php5-mcrypt | grep Installed | grep -v "(none)"`

if [[ "$PHP5_INSTALLED" == "" || "$PHP5_CURL_INSTALLED" == "" || "$PHP5_MCRYPT_INSTALLED" == "" ]]; then
    echo "ERROR: Laravel requires the php5, php5-curl and php5-mcrypt packages"
    exit 1
fi

# Install Laravel PHAR
sudo wget --no-check-certificate -O $LARAVEL_APP http://laravel.com/laravel.phar
sudo chmod +x $LARAVEL_APP

# Create laravel application
cd /vagrant
$LARAVEL_APP new laravel

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
