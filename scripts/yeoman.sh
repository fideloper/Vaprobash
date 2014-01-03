#!/usr/bin/env bash

# Test if Node.js is installed
node -v > /dev/null 2>&1
NODE_IS_INSTALLED=$?

if [ $NODE_IS_INSTALLED -eq 0 ]; then
    echo ">>> Installing Yeoman"
    npm install -g yo
else
    echo "!!! Installing Yeoman failed."
    echo "!!! Please make sure you have installed Node.js."
fi