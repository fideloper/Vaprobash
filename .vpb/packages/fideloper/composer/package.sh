#!/usr/bin/env bash

echo ">>> Installing Composer"

# Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
