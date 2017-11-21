#!/usr/bin/env bash

echo ">>> Setting up Vim"

if [[ -z $1 ]]; then
    github_url="https://raw.githubusercontent.com/rattfieldnz/Vaprobash/master"
else
    github_url="$1"
fi

# Create directories needed for some .vimrc settings
mkdir -p /home/ubuntu/.vim/backup
mkdir -p /home/ubuntu/.vim/swap

# Install Vundle and set owner of .vim files
git clone https://github.com/VundleVim/Vundle.vim.git /home/ubuntu/.vim/bundle/vundle
sudo chown -R ubuntu:ubuntu /home/ubuntu/.vim

# Grab .vimrc and set owner
curl --silent -L $github_url/helpers/vimrc > /home/ubuntu/.vimrc
sudo chown ubuntu:ubuntu /home/ubuntu/.vimrc

# Install Vundle Bundles
sudo su - ubuntu -c 'vim +BundleInstall +qall'
