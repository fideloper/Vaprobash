#!/usr/bin/env bash

echo ">>> Cleaning up"

apt-get autoremove -qq
apt-get clean -qq
