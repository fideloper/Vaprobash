#!/usr/bin/env bash

echo ">>> Setting up Vim"

# Create directories needed for some .vimrc settings
mkdir -p $HOME/.vim/backup
mkdir -p $HOME/.vim/swap

# Install Vundle and set owner of .vim files
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
sudo chown -R vagrant:vagrant $HOME/.vim

# Grab .vimrc and set owner
curl -L https://gist.githubusercontent.com/fideloper/a335872f476635b582ee/raw/.vimrc > $HOME/.vimrc
sudo chown vagrant:vagrant $HOME/.vimrc

# Install Vundle Bundles
sudo su - vagrant -c 'vim +BundleInstall +qall'
