#!/usr/bin/env bash

echo ">>> Installing Adminer"

nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

sudo mkdir /usr/share/adminer/
cd /usr/share/adminer/
sudo wget -O index.php http://www.adminer.org/latest.php

# Set and enable configuration for Apache
if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    cat << EOF | sudo tee -a /etc/apache2/conf-available/adminer.conf
Alias /adminer /usr/share/adminer

<Directory /usr/share/adminer>

    DirectoryIndex index.php
    AllowOverride None

    order deny,allow
    deny from all
    allow from all

</Directory>
EOF
    sudo a2enconf adminer

    # Reload Apache to load in configuration
    sudo service apache2 reload
fi

# Set and enable configuration for Nginx
if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    sudo ngxdis vagrant
    sudo sed -i '$ d' /etc/nginx/sites-available/vagrant
sudo tee -a /etc/nginx/sites-available/vagrant > /dev/null <<'EOF'

    location /adminer {
       root /usr/share/;
       index index.php index.html index.htm;
       location ~ ^/adminer/(.+\.php)$ {
           try_files $uri =404;
           root /usr/share/;
           fastcgi_pass unix:/var/run/php5-fpm.sock;
           fastcgi_index index.php;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include /etc/nginx/fastcgi_params;
       }
       location ~* ^/adminer/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
           root /usr/share/;
       }
    }

    location /Adminer {
       rewrite ^/* /adminer last;
    }
}
EOF
    sudo ngxen vagrant

    sudo service nginx reload
fi
