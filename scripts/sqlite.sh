#!/usr/bin/env bash

echo ">>> Installing SQLite Server"

# Install MySQL Server
# -qq implies -y --force-yes
sudo apt-get install -qq sqlite
