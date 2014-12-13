#!/usr/bin/env bash

echo ">>> Installing ansible";

# Install software-properties-common
sudo apt-get install -y software-properties-common

# Add repository
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update

# Intall ansible
sudo apt-get install -y ansible
