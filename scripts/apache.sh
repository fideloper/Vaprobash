#!/usr/bin/env bash

echo ">>> Installing Apache Server"

[[ -z "$1" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

# Add repo for latest FULL stable Apache
# (Required to remove conflicts with PHP PPA due to partial Apache upgrade within it)
sudo add-apt-repository -y ppa:ondrej/apache2

# Update Again
sudo apt-get update

# Install Apache
sudo apt-get install -y apache2-mpm-event libapache2-mod-fastcgi

echo ">>> Configuring Apache"

# Apache Config
sudo a2enmod rewrite actions
curl https://gist.github.com/fideloper/2710970/raw/vhost.sh > vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin

# Create a virtualhost to start
sudo vhost -s $1.xip.io -d /vagrant

# PHP Config for Apache
cat > /etc/apache2/conf-available/php5-fpm.conf << EOF
<IfModule mod_fastcgi.c>
        AddHandler php5-fcgi .php
        Action php5-fcgi /php5-fcgi
        Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
        FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization
        <Directory /usr/lib/cgi-bin>
                Options ExecCGI FollowSymLinks
                SetHandler fastcgi-script
                Require all granted
        </Directory>
</IfModule>
EOF
sudo a2enconf php5-fpm

sudo service apache2 restart
