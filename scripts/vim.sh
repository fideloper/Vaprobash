#!/usr/bin/env bash

echo ">>> Setting up Vim"

# Create directories needed for some .vimrc settings
mkdir -p /home/vagrant/.vim/backup
mkdir -p /home/vagrant/.vim/swap

# Install Vundle and set owner of .vim files
git clone https://github.com/gmarik/vundle.git /home/vagrant/.vim/bundle/vundle
sudo chown -R vagrant:vagrant /home/vagrant/.vim

# Grab .vimrc and set owner
curl -L https://gist.githubusercontent.com/fideloper/a335872f476635b582ee/raw/.vimrc > /home/vagrant/.vimrc
sudo chown vagrant:vagrant /home/vagrant/.vimrc

# Install Vundle Bundles
sudo su - vagrant -c 'vim +BundleInstall +qall'
