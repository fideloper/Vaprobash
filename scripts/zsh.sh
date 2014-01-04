#!/usr/bin/env bash

echo ">>> Installing Oh-My-Zsh"

# Install zsh
sudo apt-get install -y zsh

# Install oh-my-zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

# Change vagrant user's default shell
sudo su - vagrant -c 'chsh -s `which zsh`'
