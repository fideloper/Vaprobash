#!/usr/bin/env bash

echo "Adding user $1"

sudo useradd -d /home/$1 -m -k /vagrant/user_skel $1
sudo chmod 600 /home/$1/.ssh/id_*
