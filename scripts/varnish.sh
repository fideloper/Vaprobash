#!/usr/bin/env bash

echo ">>> Installing Varnish Server $1 ..."

# Check if varnish source list
if [ -e /etc/apt/sources.list.d/varnish-cache.list ]; then
  echo "Varnish repo already installed"

else
  echo "Installing Varnish repo ..."
  curl https://repo.varnish-cache.org/GPG-key.txt | sudo apt-key add -

  # Could use Distro Release?
  cat << EOF | sudo tee /etc/apt/sources.list.d/varnish-cache.list
# https://www.varnish-cache.org/installation/ubuntu
deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-$1.0
EOF

  sudo apt-get -qq install apt-transport-https
  # Update Again
  sudo apt-get update

fi

# Install varnish Server
# -qq implies -y --force-yes
sudo apt-get -qq install varnish

# ToDo - Check dependencies / Change ports for Web Server

# Update Web server and Varnish link
if [ $2 == "true" ]; then

  nginx -v > /dev/null 2>&1
  NGINX_IS_INSTALLED=$?

  apache2 -v > /dev/null 2>&1
  APACHE_IS_INSTALLED=$?

  # Set and enable configuration for Apache
  if [ $APACHE_IS_INSTALLED -eq 0 ]; then
    # Change the port Apache listens on from 80 to 8080
    sudo sed -i 's/^Listen\ 80$/Listen\ 8080/' /etc/apache2/ports.conf

    # Reload Apache to load in configuration
    sudo service apache2 reload
  fi

  # Set and enable configuration for Nginx
  if [ $NGINX_IS_INSTALLED -eq 0 ]; then
    # Change the port Nginx listens on from 80 to 8080 for all enabled sites
    sudo sed -i 's/listen\ 80;$/listen\ 8080;/' /etc/nginx/sites-enabled/*

    # Reload Nginx to load in configuration
    sudo service nginx reload
  fi

  # Set Varnish to listen on port 80
#  DAEMON_OPTS="-a :6081 \
#             -T localhost:6082 \
#             -f /etc/varnish/default.vcl \
#             -S /etc/varnish/secret \
#             -s malloc,256m"
  sudo sed -i.ssk 's/^DAEMON_OPTS=\"-a\ :6081\ \\$/DAEMON_OPTS=\"-a\ :80\ \\/' /etc/default/varnish
  sudo service varnish restart
fi

echo ">>> Installed Varnish Server $1 <<<"
