#!/usr/bin/env bash

echo ">>> Installing Apache Server"

# Install Apache
sudo apt-get install -y apache2 libapache2-mod-php5

echo ">>> Configuring Apache"

# Apache Config
sudo a2enmod rewrite
curl https://gist.github.com/fideloper/2710970/raw/vhost.sh > vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin

# Create a virtualhost to start
sudo vhost -s 192.168.33.10.xip.io -d /vagrant

sudo service apache2 restart
