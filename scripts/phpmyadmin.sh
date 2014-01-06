#!/usr/bin/env bash

echo ">>> Installing phpMyAdmin"

# TO DO: Source user/pass or set variables
# within Vagrantfile?
# This is hard-coded twice now.
MYSQL_ROOT_PASS=root

# Add PPA for phpMyAdmin
sudo add-apt-repository -y ppa:nijel/phpmyadmin

# Update latest repos
sudo apt-get update

nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Set needed configurations to run install via CLI
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
else
    echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect" | debconf-set-selections
fi
echo "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/setup-password password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/database-type select mysql" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/mysql/app-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/mysql/app-pass password" | debconf-set-selections
echo "dbconfig-common dbconfig-common/password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "dbconfig-common dbconfig-common/password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections

# Install phpMyAdmin
sudo apt-get install -y phpmyadmin

if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    # Configure Nginx
    sudo ngxdis vagrant
    sudo sed -i '$ d' /etc/nginx/sites-available/vagrant
sudo tee -a /etc/nginx/sites-available/vagrant > /dev/null <<'EOF'

    location /phpmyadmin {
       root /usr/share/;
       index index.php index.html index.htm;
       location ~ ^/phpmyadmin/(.+\.php)$ {
           try_files $uri =404;
           root /usr/share/;
           fastcgi_pass unix:/var/run/php5-fpm.sock;
           fastcgi_index index.php;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include /etc/nginx/fastcgi_params;
       }
       location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
           root /usr/share/;
       }
    }

    location /phpMyAdmin {
       rewrite ^/* /phpmyadmin last;
    }
}
EOF
    sudo ngxen vagrant

    sudo service nginx reload
fi
