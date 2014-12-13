#!/usr/bin/env bash

# Test if git is installed
git --version > /dev/null 2>&1
GIT_IS_INSTALLED=$?

if [[ $GIT_IS_INSTALLED -gt 0 ]]; then
    echo ">>> ERROR: git-ftp install requires git"
    exit 1
fi

# Test if cURL is installed
curl --version > /dev/null 2>&1
CURL_IS_INSTALLED=$?

if [ $CURL_IS_INSTALLED -gt 0 ]; then
    echo ">>> ERROR: git-ftp install requires cURL"
    exit 1
fi

echo ">>> Installing git-ftp";

# Clone git-ftp into .git-ftp folder
git clone https://github.com/git-ftp/git-ftp.git /home/vagrant/.git-ftp

# Move to the .git-ftp folder
cd /home/vagrant/.git-ftp

# Install git-ftp
sudo make install
