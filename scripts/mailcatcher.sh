#!/usr/bin/env bash

echo ">>> Installing Mailcatcher"

#dependency
sudo apt-get install -y libsqlite3-dev


if $(which rvm) -v > /dev/null 2>&1; then
	echo ">>>>Installing with RVM"
	$(which rvm) default@mailcatcher --create do gem install --no-rdoc --no-ri mailcatcher
	$(which rvm) wrapper default@mailcatcher --no-prefix mailcatcher catchmail
else
	#gem check
	if ! gem -v > /dev/null 2>&1; then sudo aptitude install -y libgemplugin-ruby; fi

	#install
	gem install --no-rdoc --no-ri mailcatcher
fi


#make it start on boot
sudo echo "@reboot $(which mailcatcher) --ip=0.0.0.0" >> /etc/crontab
sudo update-rc.d cron defaults

#make php use it to send mail
sudo echo "sendmail_path = /usr/bin/env $(which catchmail)" >> /etc/php5/mods-available/mailcatcher.ini
sudo php5enmod mailcatcher
sudo service php5-fpm restart
sudo service apache2 restart

#start it now
/usr/bin/env $(which mailcatcher) --ip=0.0.0.0

#add aliases
if [[ -f "/home/vagrant/.profile" ]]; then
	sudo echo "\nalias mailcatcher=\"mailcatcher --ip=0.0.0.0\"" >> /home/vagrant/.profile
	. /home/vagrant/.profile
fi

if [[ -f "/home/vagrant/.zshrc" ]]; then
	sudo echo "\nalias mailcatcher=\"mailcatcher --ip=0.0.0.0\"" >> /home/vagrant/.zshrc
	. /home/vagrant/.zshrc
fi
