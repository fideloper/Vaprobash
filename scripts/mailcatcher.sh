#!/usr/bin/env bash

echo ">>> Installing Mailcatcher"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$1

# Test if Apache is installed
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Source .profile for RVM, if available
if [[ -f "/home/vagrant/.profile" ]]; then
	source /home/vagrant/.profile
fi

# Installing sqlite dependency
# -qq implies -y --force-yes
sudo apt-get install -qq libsqlite3-dev

if $(which rvm) -v > /dev/null 2>&1; then
	echo ">>>>Installing with RVM"
	$(which rvm) default@mailcatcher --create do gem install --no-rdoc --no-ri mailcatcher
	$(which rvm) wrapper default@mailcatcher --no-prefix mailcatcher catchmail
else
	# Installing ruby dependency
	# -qq implies -y --force-yes
	sudo apt-get install -qq ruby1.9.1-dev

	# Gem check
	if ! gem -v > /dev/null 2>&1; then sudo aptitude install -y libgemplugin-ruby; fi

	# Install Mailcatcher gem dependencies, otherwise Ruby 2.0.0+ is required
	gem install --no-rdoc --no-ri mail -v 2.6.3 # Last known working with Ruby < 2.0.0
	gem install --no-rdoc --no-ri activesupport -v "~> 4.0"
	gem install --no-rdoc --no-ri eventmachine -v 1.0.9.1
	gem install --no-rdoc --no-ri rack -v "~> 1.5"
	gem install --no-rdoc --no-ri sinatra -v "~> 1.2"
	gem install --no-rdoc --no-ri skinny -v "~> 0.2.3"
	gem install --no-rdoc --no-ri sqlite3 -v "~> 1.3"
	gem install --no-rdoc --no-ri thin -v "~> 1.5.0"

	# Install
	gem install --no-rdoc --no-ri --ignore-dependencies mailcatcher -v "~> 0.6"
fi

# Make it start on boot
sudo tee /etc/init/mailcatcher.conf <<EOL
description "Mailcatcher"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0
EOL

# Start Mailcatcher
sudo service mailcatcher start

if [[ $PHP_IS_INSTALLED -eq 0 ]]; then
	# Make php use it to send mail
    echo "sendmail_path = /usr/bin/env $(which catchmail)" | sudo tee /etc/php5/mods-available/mailcatcher.ini
	sudo php5enmod mailcatcher
	sudo service php5-fpm restart
fi

if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
	sudo service apache2 restart
fi
