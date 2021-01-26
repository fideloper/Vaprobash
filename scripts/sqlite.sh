#!/usr/bin/env bash

echo ">>> Installing SQLite Server"

# Install SQLite Server
# -qq implies -y --force-yes
sudo apt-get install -qq sqlite

sudo apt -f -y autoremove --purge
