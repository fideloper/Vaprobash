#!/usr/bin/env bash

# Test if NodeJS is installed
node -v > /dev/null 2>&1
NODE_IS_INSTALLED=$?

if [[ $NODE_IS_INSTALLED -eq 0 ]]; then

    # Check if there are any packages given to be installed
    ARGS=($@)
    if [[ ${#ARGS[@]} -eq 0 ]]; then
        echo ">>> Skipped installing Global Node Packages"
        echo "    There are no packages given to be installed"
        exit 0
    fi

    echo ">>> Installing Global Node Packages"
    echo "    Installing " $@
    npm install -g $@
else
    echo "!!! Installing Global Node Packages failed."
    echo "!!! Please make sure you have installed NodeJS."
fi