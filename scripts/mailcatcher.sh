#!/usr/bin/env bash

echo ">>> Installing Mailcatcher"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$1

# Test if Apache is installed
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Installing dependency
sudo apt-get install -y libsqlite3-dev

# Check if RVM is installed
rvm -v > /dev/null 2>&1
RVM_IS_INSTALLED=$?

if [[ $RVM_IS_INSTALLED -eq 0 ]]; then
	echo ">>>>Installing with RVM"
	rvm default@mailcatcher --create do gem install mailcatcher --no-rdoc --no-ri
	rvm wrapper default@mailcatcher --no-prefix mailcatcher catchmail
else
	#gem check
	sudo aptitude install -y libgemplugin-ruby;

	#install
	sudo su vagrant -c 'sudo gem install mailcatcher --no-ri --no-rdoc'
fi

# Make it start on boot (This may not work)
sudo echo "@reboot $(which mailcatcher) --ip=0.0.0.0" >> /etc/crontab
sudo update-rc.d cron defaults

if [[ $PHP_IS_INSTALLED ]]; then
	# Make php use it to send mail
	sudo echo "sendmail_path = /usr/bin/env $(which catchmail)" >> /etc/php5/mods-available/mailcatcher.ini
	sudo php5enmod mailcatcher
	sudo service php5-fpm restart
fi

if [[ $APACHE_IS_INSTALLED ]]; then
	sudo service apache2 restart
fi

#add aliases
if [[ -f "/home/vagrant/.profile" ]]; then
	echo -e "\nalias mailcatcher=\"mailcatcher --ip=0.0.0.0\"" >> /home/vagrant/.profile
	. /home/vagrant/.profile
fi

if [[ -f "/home/vagrant/.zshrc" ]]; then
	echo -e "\nalias mailcatcher=\"mailcatcher --ip=0.0.0.0\"" >> /home/vagrant/.zshrc
	. /home/vagrant/.zshrc
fi

#start it
sudo su vagrant -c "mailcatcher --ip=0.0.0.0"
