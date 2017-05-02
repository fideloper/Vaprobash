#!/usr/bin/env bash

echo ">>> Installing tutum-cli"

#Install tutum-cli
apt-get install -qq python-pip
pip install tutum
