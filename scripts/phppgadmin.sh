#!/usr/bin/env bash

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    echo ">>> Installing phpPgAdmin"

    # Install phpPgAdmin depending on Apache
    sudo apt-get install -y phppgadmin

    # Allow logging in with user 'root'
    sudo sed -i "s/$conf\['extra_login_security'\] = true;/$conf\['extra_login_security'\] = false;/" /usr/share/phppgadmin/conf/config.inc.php

    # Set and enable configuration for Apache
    sudo mv /etc/apache2/conf.d/phppgadmin /etc/apache2/conf-available/phppgadmin.conf
    sudo sed -i "s/allow from 127.0.0.0\/255.0.0.0 ::1\/128/# allow from 127.0.0.0\/255.0.0.0 ::1\/128/" /etc/apache2/conf-available/phppgadmin.conf
    sudo sed -i "s/# allow from all/allow from all/" /etc/apache2/conf-available/phppgadmin.conf
    sudo a2enconf phppgadmin

    # Reload Apache to load in configuration
    sudo service apache2 reload
fi
