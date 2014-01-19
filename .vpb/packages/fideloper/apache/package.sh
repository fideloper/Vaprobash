#!/usr/bin/env bash

echo ">>> Installing Apache Server"

[[ -z "$ip_address" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

# Install Apache
sudo apt-get install -y apache2 php5 libapache2-mod-php5

echo ">>> Configuring Apache"

# Apache Config
sudo a2enmod rewrite
curl https://gist.github.com/fideloper/2710970/raw/vhost.sh > vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin

# Create a virtualhost to start
sudo vhost -s $ip_address.xip.io -d /vagrant

# PHP Config for Apache
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

sudo service apache2 restart
