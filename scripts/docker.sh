#!/usr/bin/env bash

echo ">>> Installing Docker"

# Install required packaes (beyond base packages)
sudo apt-get install -qq apt-transport-https ca-certificates

# Add Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

# Install Docker
# -qq implies -y --force-yes
sudo apt-get install -qq docker-ce

# Make the vagrant user able to interact with docker without sudo
if [ ! -z "$1" ]; then
	if [ "$1" == "permissions" ]; then
		echo ">>> Adding vagrant user to docker group"

		sudo usermod -a -G docker vagrant

	fi # permissions
fi # arg check
