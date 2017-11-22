#!/usr/bin/env bash

echo ">>> Installing MongoDB"

# Get key and add to sources
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list


# Update
sudo apt-get update

# Install MongoDB
# -qq implies -y --force-yes
sudo apt-get install -qq mongodb-org

# Create a unit file to manage the MongoDB service
sudo touch /etc/systemd/system/mongodb.service
sudo echo '[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/mongodb.service

sudo systemctl start mongodb

# Make MongoDB connectable from outside world without SSH tunnel
if [ $1 == "true" ]; then
    # enable remote access
    # setting the mongodb bind_ip to allow connections from everywhere
    sudo sed -i "s/bind_ip = .*/bind_ip = 0.0.0.0/" /etc/mongod.conf
fi

sudo systemctl restart mongodb
sudo systemctl enable mongodb

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

if [ $PHP_IS_INSTALLED -eq 0 ]; then
    # install dependencies
    sudo apt-get -y install php-pear php7.1-dev

    # install php extension
    echo "no" > answers.txt
    sudo pecl install mongodb < answers.txt
    rm answers.txt

    # add extension file and restart service
    sudo echo 'extension=mongodb.so' | sudo tee /etc/php/7.1/mods-available/mongo.ini

    sudo ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/fpm/conf.d/mongo.ini
    sudo ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/cli/conf.d/mongo.ini
    sudo service php7.1-fpm restart
fi
