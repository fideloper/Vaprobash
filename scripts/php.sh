#!/usr/bin/env bash

echo ">>> Installing PHP"

# Add repo for latest PHP
sudo add-apt-repository -y ppa:ondrej/php5

# Update Again
sudo apt-get update

# Install PHP
sudo apt-get install -y php5-cli php5-fpm php5-mysqlnd php5-pgsql php5-sqlite php5-curl php5-gd php5-mcrypt php5-xdebug php5-memcached php5-json

# PHP Config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

# xdebug Config
cat > /etc/php5/mods-available/xdebug.ini << EOF
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

sudo service php5-fpm restart
