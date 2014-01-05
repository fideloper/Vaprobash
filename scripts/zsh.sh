#!/usr/bin/env bash

echo ">>> Installing Oh-My-Zsh"

# Install zsh
sudo apt-get install -y zsh

# Install oh-my-zsh
sudo su - vagrant -c 'wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh'

# Change vagrant user's default shell
chsh vagrant -s $(which zsh);
