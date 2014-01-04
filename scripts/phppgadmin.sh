#!/usr/bin/env bash

echo ">>> Installing phpPgAdmin"

sudo apt-get install -y phppgadmin

sudo mv /etc/apache2/conf.d/phppgadmin /etc/apache2/conf-available/phppgadmin.conf
sudo a2enconf phppgadmin
sudo service apache2 reload
