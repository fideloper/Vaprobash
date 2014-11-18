#!/usr/bin/env bash

echo ">>> Installing Docker"

# Add Key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Add Repository
sudo sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update

# Install Docker
# -qq implies -y --force-yes
sudo apt-get install -qq lxc-docker
