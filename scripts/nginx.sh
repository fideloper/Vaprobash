#!/usr/bin/env bash

echo ">>> Installing Nginx"

[[ -z "$1" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

# Add repo for latest stable nginx
sudo add-apt-repository -y ppa:nginx/stable

# Update Again
sudo apt-get update

# Install the Rest
sudo apt-get install -y nginx

echo ">>> Configuring Nginx"

# Configure Nginx
# Note the .xip.io IP address $1 variable
# is not escaped
cat > /etc/nginx/sites-available/vagrant << EOF
server {
    root /vagrant;
    index index.html index.htm index.php;

    # Make site accessible from http://set-ip-address.xip.io
    server_name $1.xip.io;

    access_log /var/log/nginx/vagrant.com-access.log;
    error_log  /var/log/nginx/vagrant.com-error.log error;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
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

# setup the vhost generator script for nginx
sudo cp /vagrant/scripts/nginx_vhost.sh /usr/local/bin/ngxvhost
sudo chown root:root /usr/local/bin/ngxvhost
sudo chmod guo+x /usr/local/bin/ngxvhost

# Disable "default", enable "vagrant"
sudo ngxdis default
sudo ngxen vagrant

sudo service nginx restart
