#!/usr/bin/env bash

echo ">>> Installing Puppet Client"

#Add puppetlabs sources
cd ~; wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update
rm puppetlabs-release-trusty.deb

#Install puppet
#Puppet installation returns wrong error code
apt-get -qq install puppet || true
