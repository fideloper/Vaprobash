#!/usr/bin/env bash

echo ">>> Installing Couchbase Server"

# Set some variables
COUCHBASE_EDITION=community
COUCHBASE_VERSION=2.2.0 # Check http://http://www.couchbase.com/download/ for latest version
COUCHBASE_ARCH=x86_64


wget http://packages.couchbase.com/releases/$COUCHBASE_VERSION/couchbase-server-$COUCHBASE_EDITION_$COUCHBASE_VERSION_$COUCHBASE_ARCH.deb
sudo dpkg -i couchbase-server-$COUCHBASE_EDITION_$COUCHBASE_VERSION_$COUCHBASE_ARCH.deb
rm couchbase-server-$COUCHBASE_EDITION_$COUCHBASE_VERSION_$COUCHBASE_ARCH.deb

php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

dpkg -s php-pear
PEAR_IS_INSTALLED=$?

if [ $PHP_IS_INSTALLED -eq 0 ]; then

    if [ $PEAR_IS_INSTALLED -eq 1 ]; then
        sudo apt-get install php-pear
    fi

    sudo wget -O/etc/apt/sources.list.d/couchbase.list http://packages.couchbase.com/ubuntu/couchbase-ubuntu1204.list
    wget -O- http://packages.couchbase.com/ubuntu/couchbase.key | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install libcouchbase2-libevent libcouchbase-dev

    sudo pecl install couchbase
    echo "extension=couchbase.so" >> /etc/php5/fpm/php.ini
    sudo service php5-fpm restart
fi

