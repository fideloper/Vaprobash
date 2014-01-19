#!/usr/bin/env bash

# Test if Composer is installed
composer -v > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

if [[ $COMPOSER_IS_INSTALLED -eq 0 ]]; then

    # Check if there are any packages given to be installed
    ARGS=($@)
    if [[ ${#ARGS[@]} -eq 0 ]]; then
        echo ">>> Skipped installing Composer Global Packages"
        echo "    There are no packages to be installed"
        exit 0
    fi

    echo ">>> Installing Global Composer Packages"
    echo ">>> Installing " $@
    sudo composer global require $@

    # Add Composer's Global Bin to ~/.bash_profile path
    if ! grep -qsc 'composer/vendor/bin' '/home/vagrant/.bash_profile'; then
      echo ">>> Adding Composer Global bin to ~/.bash_profile path"
      printf "\n# Add Composer Global Bin to PATH\n%s" 'export PATH=$PATH:~/.composer/vendor/bin' >> /home/vagrant/.bash_profile
      # Re-source ~/.bash_profile
      . /home/vagrant/.bash_profile
    else
      echo ">>> Path already added to /home/vagrant/.bash_profile"
    fi

    # Add Composer's Global Bin to ~/.zshrc path
    if ! grep -qsc 'composer/vendor/bin' '/home/vagrant/.zshrc'; then
      echo ">>> Adding Composer Global bin to ~/.zshrc path"
      printf "\n# Add Composer Global Bin to PATH\n%s" 'export PATH=$PATH:~/.composer/vendor/bin' >> /home/vagrant/.zshrc
      . /home/vagrant/.zshrc
    else
      echo ">>> Path already added to /home/vagrant/.zshrc"
    fi

else
    echo "!!! Installing Global Composer Packages failed."
    echo "!!! Please make sure you have installed Composer."
fi