#!/usr/bin/env bash

echo ">>> Installing HHVM"

# Get key and add to sources
sudo add-apt-repository -y ppa:mapnik/boost
wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list

# Update
sudo apt-get update

# Install HHVM
sudo apt-get install -y hhvm

# Use as FastCGI?
if [ "$1" == "true" ]; then
    sudo /usr/share/hhvm/install_fastcgi.sh
    sudo service hhvm restart

    # This needs extra work to add to laravel nginx config or 192.168.33.10.xip.io apache config
fi

# Replace PHP with HHVM via symlinking
if [ "$2" == "true" ]; then
    sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60
fi
