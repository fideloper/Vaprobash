#!/usr/bin/env bash

echo ">>> Installing PHPUnit"

# PHPUnit
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit
