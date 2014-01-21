#!/usr/bin/env bash

echo ">>> Installing Beanstalkd"

# Install Beanstalkd
sudo apt-get install -y beanstalkd

# Set to start on system start
sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd

# Start Beanstalkd
sudo service beanstalkd start
