#!/usr/bin/env bash

echo ">>> Installing Nginx"

# Add repo for latest stable nginx
sudo add-apt-repository -y ppa:nginx/stable

# Update Again
sudo apt-get update

# Install the Rest
sudo apt-get install -y nginx php5-fpm

echo ">>> Configuring Nginx"

# Configure Nginx
cat > /etc/nginx/sites-available/vagrant << EOF
server {
    root /vagrant;
    index index.html index.htm index.php;

    # Make site accessible from http://192.168.33.10.xip.io/
    server_name 192.168.33.10.xip.io;

    access_log /var/log/nginx/vagrant.com-access.log;
    error_log  /var/log/nginx/vagrant.com-error.log error;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?q=\$uri&\$args;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    # pass the PHP scripts to php5-fpm
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        # With php5-fpm:
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param LARA_ENV local; # Environment variable for Laravel
        include fastcgi_params;
    }

    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
}
EOF

# Nginx enabling and disabling virtual hosts
curl https://gist.github.com/fideloper/8261546/raw/ngxen > ngxen
curl https://gist.github.com/fideloper/8261546/raw/ngxdis > ngxdis
sudo chmod guo+x ngxen ngxdis
sudo mv ngxen ngxdis /usr/local/bin

# Disable "default", enable "vagrant"
sudo ngxdis default
sudo ngxen vagrant

# PHP Config for Nginx
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

sudo service php5-fpm restart
sudo service nginx restart