#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

echo ">>> Installing Nginx"

[[ -z "$1" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [ -z "$2" ]; then
    public_folder="/vagrant"
else
    public_folder="$2"
fi

# Add repo for latest stable nginx
sudo add-apt-repository -y ppa:nginx/stable

# Update Again
sudo apt-get update

# Install the Rest
sudo apt-get install -y nginx

echo ">>> Configuring Nginx"

if [[ $PHP_IS_INSTALLED -eq 0 ]]; then

    read -d '' PHP_NO_SSL <<EOF
        # pass the PHP scripts to php5-fpm
        # Note: \.php$ is susceptible to file upload attacks
        # Consider using: "location ~ ^/(index|app|app_dev|config)\.php(/|$) {"
        location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            # With php5-fpm:
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            fastcgi_param LARA_ENV local; # Environment variable for Laravel
            fastcgi_param HTTPS off;
        }
EOF

    read -d '' PHP_WITH_SSL <<EOF
        # pass the PHP scripts to php5-fpm
        # Note: \.php$ is susceptible to file upload attacks
        # Consider using: "location ~ ^/(index|app|app_dev|config)\.php(/|$) {"
        location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            # With php5-fpm:
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            fastcgi_param LARA_ENV local; # Environment variable for Laravel
            fastcgi_param HTTPS on;
        }
EOF
else
    PHP_NO_SSL = ""
    PHP_WITH_SSL = ""
fi

# Configure Nginx
# Note the .xip.io IP address $1 variable
# is not escaped
cat > /etc/nginx/sites-available/vagrant << EOF
server {
    listen 80;

    root $public_folder;
    index index.html index.htm index.php app.php app_dev.php;

    # Make site accessible from http://set-ip-address.xip.io
    server_name $1.xip.io $3;

    access_log /var/log/nginx/vagrant.com-access.log;
    error_log  /var/log/nginx/vagrant.com-error.log error;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /app.php?\$query_string /index.php?\$query_string;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    $PHP_NO_SSL

    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
}

server {
    listen 443;

    ssl on;
    ssl_certificate     /etc/ssl/xip.io/xip.io.crt;
    ssl_certificate_key /etc/ssl/xip.io/xip.io.key;

    root $public_folder;
    index index.html index.htm index.php app.php app_dev.php;

    # Make site accessible from http://set-ip-address.xip.io
    server_name $1.xip.io $3;

    access_log /var/log/nginx/vagrant.com-access.log;
    error_log  /var/log/nginx/vagrant.com-error.log error;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /app.php?\$query_string /index.php?\$query_string;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    $PHP_WITH_SSL

    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
}
EOF

# Turn off sendfile to be more compatible with Windows, which can't use NFS
sed -i 's/sendfile on;/sendfile off;/' /etc/nginx/nginx.conf

# Nginx enabling and disabling virtual hosts
curl -L https://gist.githubusercontent.com/fideloper/8261546/raw/ngxen > ngxen
curl -L https://gist.githubusercontent.com/fideloper/8261546/raw/ngxdis > ngxdis
sudo chmod guo+x ngxen ngxdis
sudo mv ngxen ngxdis /usr/local/bin

# Setup the vhost generator script for nginx
# This sould be used for the above setup eventually, rather
# than the hard-coded config above!
curl -L https://gist.githubusercontent.com/fideloper/9063376/raw/ngxhost.sh > ngxvhost
sudo chown root:root ngxvhost
sudo chmod guo+x ngxvhost
sudo mv ngxvhost /usr/local/bin

# Disable "default", enable "vagrant"
sudo ngxdis default
sudo ngxen vagrant

if [[ $PHP_IS_INSTALLED -eq 0 ]]; then
    # PHP Config for Nginx
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

    sudo service php5-fpm restart
fi

sudo service nginx restart
