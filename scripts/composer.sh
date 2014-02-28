#!/usr/bin/env bash

php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

if [[ $PHP_IS_INSTALLED -ne 0 ]]; then
    echo "!!! Installing composer stopped!"
    echo "    Make sure you install php first!"
    exit 0
fi

# Test if Composer is installed
composer -v > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

# Retrieve the Global Composer Packages, if any are given
COMPOSER_PACKAGES=($@)

# True, if composer is not installed
if [[ $COMPOSER_IS_INSTALLED -ne 0 ]]; then
    echo ">>> Installing Composer"

    # Install Composer
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
else
    echo ">>> Updating Composer"

    # Update Composer
    sudo composer self-update
fi

# Install Global Composer Packages if any are given
if [[ ! -z $COMPOSER_PACKAGES ]]; then

    echo ">>> Installing Global Composer Packages:"
    echo "    " $@
    sudo composer global require $@

    # Add Composer's Global Bin to ~/.profile path
    if ! grep -qsc 'composer/vendor/bin' '/home/vagrant/.profile'; then
      echo ">>> Adding Composer Global bin to ~/.profile path"
      printf "\n# Add Composer Global Bin to PATH\n%s" 'export PATH=$PATH:~/.composer/vendor/bin' >> /home/vagrant/.profile
      # Re-source ~/.profile
      . /home/vagrant/.profile
    else
      echo ">>> Composer's bin path already added to /home/vagrant/.profile"
    fi

    # Add Composer's Global Bin to ~/.zshrc path
    if ! grep -qsc 'composer/vendor/bin' '/home/vagrant/.zshrc'; then
      echo ">>> Adding Composer Global bin to ~/.zshrc path"
      printf "\n# Add Composer Global Bin to PATH\n%s" 'export PATH=$PATH:~/.composer/vendor/bin' >> /home/vagrant/.zshrc
      . /home/vagrant/.zshrc
    else
      echo ">>> Composer's bin path already added to /home/vagrant/.zshrc"
    fi

fi
