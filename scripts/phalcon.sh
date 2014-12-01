#!/usr/bin/env bash

echo ">>> Installing Phalcon"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

[[ $PHP_IS_INSTALLED -ne 0 ]] && { printf "!!! PHP is not installed.\n    Installing Phalcon aborted!\n"; exit 0; }

# Get su permission
sudo -i

# Requiments packages 
apt-get install php5-dev libpcre3-dev gcc make  -y

# Clone the repo
git clone --depth=1 https://github.com/phalcon/cphalcon.git
cd cphalcon/ext
echo 'Building Phalcon'

# Run build script
cd ext
phpize && ./configure && make && make install
wait

# write ini config
if ! (php --ri phalcon &>/dev/null); then
    if [ -d "/etc/php.d" ]; then #centos, etc
        echo 'extension=phalcon.so' > /etc/php.d/phalcon.ini
    elif [ -d "/etc/php5/mods-available" ]; then #debian-like
        echo 'extension=phalcon.so' > /etc/php5/mods-available/phalcon.ini
        [ -d '/etc/php5/cli' ] && ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/cli/conf.d/phalcon.ini
        [ -d '/etc/php5/apache' ] && ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/apache2/conf.d/phalcon.ini
        [ -d '/etc/php5/fpm' ] && ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/fpm/conf.d/phalcon.ini
    elif [ -d "/etc/php5/conf.d" ]; then #debian-like old way
        echo 'extension=phalcon.so' > /etc/php5/conf.d/phalcon.ini
    else
        echo 'Warning: can not find php modules config dir. You should write phalcon.ini manually' >&2
    fi
fi

# Restart apache or php5-fpm and nginx
echo
echo 'Restarting web services'
echo
service php5-fpm status &>/dev/null && service php5-fpm restart
service nginx status &>/dev/null && service nginx restart
service apache2 status &>/dev/null && service apache2 restart

# Clean up
exit
