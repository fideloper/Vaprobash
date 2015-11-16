#!/usr/bin/env bash

echo ">>> Installing phpMyAdmin"

# Test if Apache is installed
apache2 -v > /dev/null 2>&1 || { printf "!!! Apache is not installed.\n    Installing phpMyAdmin aborted!\n"; exit 0; }

# Test if PHP is installed
php -v > /dev/null 2>&1 || { printf "!!! PHP is not installed.\n    Installing phpMyAdmin aborted!\n"; exit 0; }

# Configure phpMyAdmin
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $1" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $1" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $1" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

# Install phpMyAdmin
export DEBIAN_FRONTEND=noninteractive
apt-get install -qq phpmyadmin

# Configure Apache 2

echo "
Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
        Options FollowSymLinks
        DirectoryIndex index.php

        <FilesMatch \.php$>
            SetHandler "proxy:fcgi://127.0.0.1:9000"
        </FilesMatch>

</Directory>

<Directory /usr/share/phpmyadmin/setup>
    <IfModule mod_authn_file.c>
    AuthType Basic
    AuthName \"phpMyAdmin Setup\"
    AuthUserFile /etc/phpmyadmin/htpasswd.setup
    </IfModule>
    Require valid-user
</Directory>

<Directory /usr/share/phpmyadmin/libraries>
    Order Deny,Allow
    Deny from All
</Directory>

<Directory /usr/share/phpmyadmin/setup/lib>
    Order Deny,Allow
    Deny from All
</Directory>
" > /etc/apache2/conf-enabled/phpmyadmin.conf

# Restart Apache
/etc/init.d/apache2 restart
