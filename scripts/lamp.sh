#!/usr/bin/env bash

echo ">>> Adding PPA's and Installing LAMP Server"

# Add repo for latest PHP
sudo add-apt-repository -y ppa:ondrej/php5

# Update Again
sudo apt-get update

# Install the Rest
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-mcrypt php5-xdebug

echo ">>> Configuring Server"

# xdebug Config
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

# Apache Config
sudo a2enmod rewrite
curl https://gist.github.com/fideloper/2710970/raw/vhost.sh > vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin

# Create a virtualhost to start
sudo vhost -s 192.168.33.10.xip.io -d /vagrant

# PHP Config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo ">>> Restarting Apache2"
sudo service apache2 restart
