#!/usr/bin/env bash

echo ">>> Installing Couchbase Server"

# Set some variables
COUCHBASE_EDITION=community
COUCHBASE_VERSION=6.0.3 # Check https://www.couchbase.com/downloads for latest version
COUCHBASE_ARCH=x86_64


wget --quiet http://packages.couchbase.com/releases/${COUCHBASE_VERSION}/couchbase-server-${COUCHBASE_EDITION}_${COUCHBASE_VERSION}_${COUCHBASE_ARCH}.deb
sudo dpkg -i couchbase-server-${COUCHBASE_EDITION}_${COUCHBASE_VERSION}_${COUCHBASE_ARCH}.deb
rm couchbase-server-${COUCHBASE_EDITION}_${COUCHBASE_VERSION}_${COUCHBASE_ARCH}.deb

php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

dpkg -s php-pear
PEAR_IS_INSTALLED=$?

dpkg -s php7.1-dev
PHPDEV_IS_INSTALLED=$?

if [ ${PHP_IS_INSTALLED} -eq 0 ]; then

    if [ ${PEAR_IS_INSTALLED} -eq 1 ]; then
        sudo apt-get -qq install php-pear
    fi

    if [ ${PHPDEV_IS_INSTALLED} -eq 1 ]; then
        sudo apt-get -qq install php-dev
    fi

    sudo wget --quiet -O/etc/apt/sources.list.d/couchbase.list http://packages.couchbase.com/ubuntu/couchbase-ubuntu1204.list
    wget --quiet -O- http://packages.couchbase.com/ubuntu/couchbase.key | sudo apt-key add -
    sudo apt-get update
    sudo apt-get -qq install libcouchbase2-libevent libcouchbase-dev
	
	sudo pecl channel-update pecl.php.net
    sudo pecl install couchbase-${COUCHBASE_VERSION}
    sudo cat > /etc/php/7.1/mods-available/couchbase.ini << EOF
; configuration for php couchbase module
; priority=30
extension=couchbase.so
EOF
    sudo php7.1enmod couchbase
    sudo service php7.1-fpm restart
fi

sudo apt -f -y autoremove --purge
