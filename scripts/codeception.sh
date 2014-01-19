#!/usr/bin/env bash

echo ">>> Installing Codeception"

# Codeception
wget http://codeception.com/codecept.phar
chmod +x codecept.phar
mv codecept.phar /usr/local/bin/codecept
