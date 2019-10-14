#!/usr/bin/env bash

echo "Setting Timezone & Locale to $3 & en_NZ.UTF-8"

# Update
sudo apt-get update && sudo apt-get -f -y upgrade && sudo apt-get -f -y dist-upgrade

sudo ln -sf /usr/share/zoneinfo/$3 /etc/localtime
sudo apt-get install -qq language-pack-en
sudo locale-gen en_NZ
sudo update-locale LANG=en_NZ.UTF-8 LC_CTYPE=en_NZ.UTF-8

echo ">>> Installing Base Packages"

# Install base packages
# -qq implies -y --force-yes
sudo apt-get install -qq vim build-essential python-software-properties git zip unzip tcl curl git-core ack-grep software-properties-common cachefilesd virtualbox-guest-dkms openssl pkg-config libssl-dev libsslcommon2-dev libpng-dev libjpeg-dev libwebp-dev imagemagick libmagickcore-dev libmagickwand-dev resolvconf network-manager

sudo echo "nameserver 192.168.1.100 1.1.1.1" > /etc/resolvconf/resolv.conf.d/base
sudo service resolvconf restart
sudo service networkd-dispatcher restart
sudo service network-manager restart

echo ">>> Installing *.xip.io self-signed SSL"

SSL_DIR="/etc/ssl/xip.io"
DOMAIN="*.xip.io"
PASSPHRASE="vaprobash"

SUBJ="
C=US
ST=California
O=Vaprobash
localityName=Los Angeles
commonName=$DOMAIN
organizationalUnitName=Vaprobash
emailAddress=vaprobash@test.com
"

sudo mkdir -p "$SSL_DIR"

sudo openssl genrsa -out "$SSL_DIR/xip.io.key" 1024
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/xip.io.key" -out "$SSL_DIR/xip.io.csr" -passin pass:$PASSPHRASE
sudo openssl x509 -req -days 365 -in "$SSL_DIR/xip.io.csr" -signkey "$SSL_DIR/xip.io.key" -out "$SSL_DIR/xip.io.crt"

# Setting up Swap

# Disable case sensitivity
shopt -s nocasematch

if [[ ! -z $2 && ! $2 =~ false && $2 =~ ^[0-9]*$ ]]; then

    echo ">>> Setting up Swap ($2 MB)"

    # Create the Swap file
    fallocate -l $2M /swapfile

    # Set the correct Swap permissions
    chmod 600 /swapfile

    # Setup Swap space
    mkswap /swapfile

    # Enable Swap space
    swapon /swapfile

    # Make the Swap file permanent
    echo "/swapfile   none    swap    sw    0   0" | tee -a /etc/fstab

    # Add some swap settings:
    # vm.swappiness=10: Means that there wont be a Swap file until memory hits 90% useage
    # vm.vfs_cache_pressure=50: read http://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that
    printf "vm.swappiness=10\nvm.vfs_cache_pressure=50" | tee -a /etc/sysctl.conf && sysctl -p

fi

# Enable case sensitivity
shopt -u nocasematch

# Enable cachefilesd
echo "RUN=yes" > /etc/default/cachefilesd
