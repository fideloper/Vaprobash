#!/usr/bin/env bash

echo ">>> Installing Base Packages"

# Update
sudo apt-get update

# Install base packages
sudo apt-get install -y git-core ack-grep vim tmux curl wget build-essential python-software-properties

# Git Config and set Owner
curl -L https://gist.githubusercontent.com/fideloper/2710970/raw/vhost.sh > /home/vagrant/.gitconfig
sudo chown vagrant:vagrant /home/vagrant/.gitconfig

echo ">>> Installing *.xio.io self-signed SSL"

SSL_DIR="/etc/ssl/xip.io"
DOMAIN="*.xip.io"
PASSPHRASE="vaprobash"

SUBJ="
C=US
ST=Connecticut
O=Vaprobash
localityName=New Haven
commonName=$DOMAIN
organizationalUnitName=
emailAddress=
"

sudo mkdir -p "$SSL_DIR"

sudo openssl genrsa -out "$SSL_DIR/xip.io.key" 1024
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/xip.io.key" -out "$SSL_DIR/xip.io.csr" -passin pass:$PASSPHRASE
sudo openssl x509 -req -days 365 -in "$SSL_DIR/xip.io.csr" -signkey "$SSL_DIR/xip.io.key" -out "$SSL_DIR/xip.io.crt"
