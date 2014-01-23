#!/usr/bin/env bash

echo ">>> Installing Magento"

[[ -z "$1" ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

# Test if mysql is installed
mysql --version > /dev/null 2>&1
MYSQL_IS_INSTALLED=$?

if [ $MYSQL_IS_INSTALLED -gt 0 ]; then
  echo "ERROR: Magento requires mysql."
  exit 1
fi

# Test if Composer is installed
composer --version > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

if [ $COMPOSER_IS_INSTALLED -gt 0 ]; then
    echo "ERROR: Magento install requires composer"
    exit 1
fi

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

# Create Magento
if [ $HHVM_IS_INSTALLED -eq 0 ]; then
  hhvm /usr/local/bin/composer create-project --stability="dev" --keep-vcs --prefer-dist magetest/magento /vagrant/magento
else
  composer create-project --stability="dev" --keep-vcs --prefer-dist magetest/magento /vagrant/magento
fi

# Set new document root on Apache or Nginx
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

if [ $NGINX_IS_INSTALLED -eq 0 ]; then
  # Remove the default vhost created
  # Magento requires specific stuff for Nginx
  rm -f /etc/nginx/sites-available/vagrant

  cat > /etc/nginx/sites-available/magento << EOF
server {
  root /vagrant/magento/src;
  index index.html index.htm index.php;

  # Make site accessible from http://set-ip-address.xip.io
  server_name $1.xip.io;

  access_log /var/log/nginx/magento.com-access.log;
  error_log /var/log/nginx/magento.com-error.log;

  location / {
    try_files $uri $uri/ @handler;
    expires 30d;
  }

  ## These locations would be hidden by .htaccess normally
  location ^~ /app/                { deny all; }
  location ^~ /includes/           { deny all; }
  location ^~ /lib/                { deny all; }
  location ^~ /media/downloadable/ { deny all; }
  location ^~ /pkginfo/            { deny all; }
  location ^~ /report/config.xml   { deny all; }
  location ^~ /var/                { deny all; }

  location  /. { ## Disable .htaccess and other hidden files
    return 404;
  }

  ## Magento uses a common front handler
  location @handler {
    rewrite / /index.php;
  }

  ## Forward paths like /js/index.php/x.js to relevant handler
  location ~ .php/ {
    rewrite ^(.*.php)/ $1 last;
  }

  #pass the php scripts to php5-fpm
  location ~ \.php$ {
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    # With php5-fpm:
    expires off;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    fastcgi_param  MAGE_RUN_CODE default; ## Store code is defined in administration > Configuration > Manage Stores
    fastcgi_param  MAGE_RUN_TYPE store;
    include fastcgi_params;
  }
}
EOF
  sudo service nginx reload
fi

if [ $APACHE_IS_INSTALLED -eq 0 ]; then
  # Remove apache vhost from default and create a new one
  rm /etc/apache2/sites-enabled/$1.xip.io.conf > /dev/null 2>&1
  rm /etc/apache2/sites-available/$1.xip.io.conf > /dev/null 2>&1
  vhost -s $1.xip.io -d /vagrant/magento/src
  sudo service apache2 reload
fi