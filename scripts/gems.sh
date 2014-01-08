#!/usr/bin/env bash

# Test if Node.js is installed
gem -v > /dev/null 2>&1
RUBY_IS_INSTALLED=$?

if [ $RUBY_IS_INSTALLED -eq 0 ]; then
    echo ">>> Installing Gems"
    echo ">>> Installing " $@
    gem install $@
else
    echo "!!! Installing Gems failed."
    echo "!!! Please make sure you have installed Ruby and Gems."
fi
