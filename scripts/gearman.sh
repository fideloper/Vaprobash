#!/usr/bin/env bash

gearman -v > /dev/null 2>&1
GEARMAN_IS_INSTALLED=$?

dpkg -s php-pear
PEAR_IS_INSTALLED=$?

dpkg -s php5-dev
PHPDEV_IS_INSTALLED=$?

if [[ $GEARMAN_IS_INSTALLED -ne 0 ]]; then
	echo ">>> Installing Gearman"

	# Install dependencies
	sudo apt-get update
	sudo apt-get -y install gcc autoconf bison flex libtool gperf make libboost-all-dev libcurl4-openssl-dev curl libevent-dev memcached uuid-dev libsqlite3-dev libmysqlclient-dev libcloog-ppl0

	# Download version 1.1.12 of Gearman
	cd /tmp
	wget https://launchpad.net/gearmand/1.2/1.1.11/+download/gearmand-1.1.11.tar.gz
	tar -zxvf gearmand-1.1.11.tar.gz
	cd gearmand-1.1.11
	./configure
	sudo make
	sudo make install

	# Create the necessary links and cache to the most recent shared libraries. 
	# Fixes error: gearman: error while loading shared libraries: libgearman.so.6: cannot open shared object file: No such file or directory
	sudo ldconfig

	# Install pecl
	if [[ $PEAR_IS_INSTALLED -ne 0 ]]; then
		sudo apt-get -y install php-pear
	fi

	if [[ $PHPDEV_IS_INSTALLED -ne 0 ]]; then
        sudo apt-get -y install php5-dev
    fi

	# Install gearman
	sudo pecl install gearman
	echo "extension=gearman.so" | sudo tee -a /etc/php5/fpm/php.ini
    echo "extension=gearman.so" | sudo tee -a /etc/php5/cli/php.ini
    sudo service php5-fpm restart
fi

# Create log directory and start listening for events
sudo mkdir -R /usr/local/var/log