#!/usr/bin/env bash

export LANG=C.UTF-8

PHP_TIMEZONE=$1
HHVM=$2
PHP_VERSION=$3
USER=$4

PHP_INSTALL="unknow"

# detect SO version
v=`lsb_release -c | awk -F':' '{ print $2 }' | sed 's/\t//g'`
if [ $v != "xenial" ]
then
    echo "[ERROR]: You need xenial to install php 7"
    exit
fi

sudo apt-get update

# Install PHP
# -qq implies -y --force-yes
sudo apt-get install -qq php-cli php-fpm php-mysql php-pgsql php-sqlite3 php-curl php-gd php-gmp php-mcrypt php-memcached php-imagick php-intl php-xdebug

# Detect installed version of PHP
for v in 7.0 7.1 7.2 7.3 7.4
do
    if [ -d "/etc/php/$v/" ]
    then
	PHP_INSTALL=$v
    fi
done
if [ $PHP_INSTALL == "unknow" ]
then
    echo "[ERROR]: Dont know which PHP version are you using"
    exit
fi

if [ "$USER" == "" ]
then
   USER="vagrant"
   
fi

# Set PHP FPM to listen on TCP instead of Socket
sudo sed -i "s/listen =.*/listen = 127.0.0.1:9000/" "/etc/php/$PHP_INSTALL/fpm/pool.d/www.conf"

# Set PHP FPM allowed clients IP address
sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" "/etc/php/$PHP_INSTALL/fpm/pool.d/www.conf" 

# Set run-as user for PHP5-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user = www-data/user = $USER/" "/etc/php/$PHP_INSTALL/fpm/pool.d/www.conf" 
sudo sed -i "s/group = www-data/group = $USER/" "/etc/php/$PHP_INSTALL/fpm/pool.d/www.conf"

sudo sed -i "s/listen\.owner.*/listen.owner = $USER/" "/etc/php/$PHP_INSTALL/fpm/pool.d/www.conf"
sudo sed -i "s/listen\.group.*/listen.group = $USER/" "/etc/php/$PHP_INSTALL/fpm/pool.d/www.conf"
sudo sed -i "s/listen\.mode.*/listen.mode = 0666/" "/etc/php/$PHP_INSTALL/fpm/pool.d/www.conf"


# xdebug Config
cat > $(find /etc/php/$PHP_INSTALL -name xdebug.ini) << EOF
zend_extension=$(find /usr/lib/php -name xdebug.so)
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9000
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1

; var_dump display
xdebug.var_display_max_depth = 5
xdebug.var_display_max_children = 256
xdebug.var_display_max_data = 1024
EOF

# PHP Error Reporting Config
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" "/etc/php/$PHP_INSTALL/fpm/php.ini"
sudo sed -i "s/display_errors = .*/display_errors = On/" "/etc/php/$PHP_INSTALL/fpm/php.ini"

# Upload size
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 20M/" "/etc/php/$PHP_INSTALL/fpm/php.ini"
sudo sed -i "s/post_max_size = .*/post_max_size = 20M/" "/etc/php/$PHP_INSTALL/fpm/php.ini"

# PHP Date Timezone
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" "/etc/php/$PHP_INSTALL/fpm/php.ini"
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" "/etc/php/$PHP_INSTALL/cli/php.ini"

sudo service "php$PHP_INSTALL-fpm" start
