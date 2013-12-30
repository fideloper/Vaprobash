#!/usr/bin/env bash

echo ">>> Starting Install Script"

# Update
sudo apt-get update

# Install MySQL without prompt
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo ">>> Installing Base Items"

# Install base items
sudo apt-get install -y vim tmux curl wget build-essential python-software-properties

echo ">>> Adding PPA's and Installing Server Items"

# Add repo for latest PHP
sudo add-apt-repository -y ppa:ondrej/php5

# Update Again
sudo apt-get update

# Install the Rest
sudo apt-get install -y git-core nginx php5-fpm php5-cli php5-mysql php5-curl php5-gd php5-mcrypt php5-xdebug mysql-server

echo ">>> Configuring Server"

# xdebug Config
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

# Configure Nginx
cat << EOF | sudo tee -a /etc/nginx/sites-available/vagrant
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

sudo ln -s /etc/nginx/sites-available/vagrant /etc/nginx/sites-enabled/vagrant

# PHP Config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

sudo service php5-fpm restart
sudo service nginx restart

# Git Config and set Owner
curl https://gist.github.com/fideloper/3751524/raw/.gitconfig > /home/vagrant/.gitconfig
sudo chown vagrant:vagrant /home/vagrant/.gitconfig
