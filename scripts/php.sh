#!/usr/bin/env bash

# Add repo for latest PHP
sudo add-apt-repository -y ppa:ondrej/php5

# Update Again
sudo apt-get update

# Install PHP
sudo apt-get install -y php5 php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-mcrypt php5-xdebug php5-memcached

# xdebug Config
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

# PHP Config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
