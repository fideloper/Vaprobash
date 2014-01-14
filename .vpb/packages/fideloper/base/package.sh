#!/usr/bin/env bash

echo ">>> Installing Base Packages"

# Update
sudo apt-get update

# Install base packages
sudo apt-get install -y git-core ack-grep vim tmux curl wget build-essential python-software-properties

# Git Config and set Owner
curl https://gist.github.com/fideloper/3751524/raw/.gitconfig > /home/vagrant/.gitconfig
sudo chown vagrant:vagrant /home/vagrant/.gitconfig
