#!/usr/bin/env bash
#
#
if [ -z "$1" ]; then
    php_version="distributed"
else
    php_version="$1"
fi

echo ">>> Installing PHP $1 version"

if [ $php_version == "latest" ]; then
    sudo add-apt-repository -y ppa:ondrej/php5
fi

if [ $php_version == "previous" ]; then
    sudo add-apt-repository -y ppa:ondrej/php5-oldstable
fi

sudo apt-get update

# Install PHP
sudo apt-get install -y php5-cli php5-fpm php5-mysql php5-mssql php5-pgsql php5-sqlite php5-curl php5-gd php5-gmp php5-mcrypt php5-xdebug php5-memcached php5-imagick

# xdebug Config
cat > /etc/php5/mods-available/xdebug.ini << EOF
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

# PHP Error Reporting Config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

# Make sure php5-fpm is running as a Unix socket on "distributed" version
if [ $php_version == "distributed" ]; then
    sed -i "s/listen = .*/listen = \/var\/run\/php5-fpm.sock/" /etc/php5/fpm/pool.d/www.conf
fi

sudo service php5-fpm restart
