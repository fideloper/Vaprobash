#!/usr/bin/env bash

echo ">>> Installing Oh-My-Zsh"

# Install zsh
sudo apt-get install -y zsh

# Install oh-my-zsh
sudo su - vagrant -c 'wget http://install.ohmyz.sh -O - | zsh'

# Set to "blinks" theme which
# uses Solarized and shows user/host
sudo sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="blinks"/' /home/vagrant/.zshrc
# Add /sbin to PATH
sudo sed -i 's=:/bin:=:/bin:/sbin:/usr/sbin:=' /home/vagrant/.zshrc

# Change vagrant user's default shell
chsh vagrant -s $(which zsh);
