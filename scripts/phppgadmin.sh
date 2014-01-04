#!/usr/bin/env bash

echo ">>> Installing phpPgAdmin"

# Install phpPgAdmin
sudo apt-get install -y phppgadmin

# Set and enable configuration
sudo mv /etc/apache2/conf.d/phppgadmin /etc/apache2/conf-available/phppgadmin.conf
sudo a2enconf phppgadmin

# Reload Apache to load in configuration
sudo service apache2 reload
