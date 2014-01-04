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

sudo ln -s /etc/nginx/sites-available/vagrant /etc/nginx/sites-enabled/vagrant

echo ">>> Creating ngxen and ngxdis in /usr/local/bin/"
# Lightly adjusted version of: https://blog.kamal.io/post/nginx-apache-like-server-structure/

# Create ngxen
cat > /usr/local/bin/ngxen << EOF
#!/usr/bin/env bash

if [ \$EUID -ne 0 ]; then
    echo "You must be root: \"sudo ngxen\""
    exit 1
fi

# -z str: Returns True if the length of str is equal to zero.
if [ -z "\$1" ]; then
    echo "Please choose a site."
    exit 1
else
    echo "Enabling site \$1..."
    # -h filename: True if file exists and is a symbolic link.
    # -f filename: Returns True if file, filename is an ordinary file.
    if [ -h "/etc/nginx/sites-enabled/\$1" ] || [ -f "/etc/nginx/sites-enabled/\$1" ]; then
        echo "\$1 is already enabled."
        exit 1
    else
        if [ ! -f "/etc/nginx/sites-available/\$1" ]; then
            echo "Site \$1 does not exist in /etc/nginx/sites-available."
            exit 1
        else
            ln -s /etc/nginx/sites-available/\$1 /etc/nginx/sites-enabled/\$1
            echo "Enabled \$1"
            exit 0
        fi
    fi
fi
EOF

# Create ngxdis
cat > /usr/local/bin/ngxdis << EOF
#!/usr/bin/env bash

if [ \$EUID -ne 0 ]; then
    echo "You must be root: \"sudo ngxdis\""
    exit 1
fi

# -z str: Returns True if the length of str is equal to zero.
if [ -z "\$1" ]; then
    echo "Please choose a site."
    exit 1
else
    echo "Disabling site \$1..."
    # -h filename: True if file exists and is a symbolic link.
    # -f filename: Returns True if file, filename is an ordinary file.
    if [ ! -h "/etc/nginx/sites-enabled/\$1" ] && [ ! -f "/etc/nginx/sites-enabled/\$1" ]; then
        echo "\$1 is not enabled."
        exit 1
    else
        rm /etc/nginx/sites-enabled/\$1
        echo "Disabled \$1"
    fi
fi
EOF

# Make sure that ngxen and ngxdis have execution permission
sudo chmod guo+x /usr/local/bin/ngxen /usr/local/bin/ngxdis

# PHP Config for Nginx
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

sudo service php5-fpm restart
sudo service nginx restart
