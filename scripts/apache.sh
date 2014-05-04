#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

echo ">>> Installing Apache Server"

[[ -z "$1" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [ -z "$2" ]; then
	public_folder="/vagrant"
else
	public_folder="$2"
fi

# Add repo for latest FULL stable Apache
# (Required to remove conflicts with PHP PPA due to partial Apache upgrade within it)
sudo add-apt-repository -y ppa:ondrej/apache2


# Update Again
sudo apt-key update
sudo apt-get update

# Install Apache
sudo apt-get install -y --force-yes apache2

echo ">>> Configuring Apache"


# Apache Config
sudo a2enmod rewrite actions ssl
curl -L https://gist.githubusercontent.com/fideloper/2710970/raw/vhost.sh > vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin

# Create a virtualhost to start, with SSL certificate
sudo vhost -s $1.xip.io -d $public_folder -p /etc/ssl/xip.io -c xip.io -a $3

if [[ $PHP_IS_INSTALLED -eq 0 ]]; then

    # PHP Config for Apache
    sudo a2enmod proxy_fcgi

    # Add ProxyPassMatch to pass to php in document root
    sudo sed -i "s@#ProxyPassMatch.*@ProxyPassMatch ^/(.*\\\.php(/.*)?)$ fcgi://127.0.0.1:9000"$public_folder"/\$1@" /etc/apache2/sites-available/$1.xip.io.conf

fi

sudo service apache2 restart
