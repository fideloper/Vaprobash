#!/usr/bin/env bash

export LANG=C.UTF-8

PHP_TIMEZONE=$1
HHVM=$2
PHP_VERSION=$3
USER=$4

if [[ $HHVM == "true" ]]; then

    echo ">>> Installing HHVM"

    # Get key and add to sources
    wget --quiet -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
    echo deb http://dl.hhvm.com/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/hhvm.list

    # Update
    sudo apt-get update

    # Install HHVM
    # -qq implies -y --force-yes
    sudo apt-get install -qq hhvm

    # Start on system boot
    sudo update-rc.d hhvm defaults

    # Replace PHP with HHVM via symlinking
    sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

    sudo service hhvm restart
else
    echo ">>> Installing PHP $PHP_VERSION"

    if [ $PHP_VERSION == "5.5" -o $PHP_VERSION == "5.6" -o $PHP_VERSION == "5" ]
    then
        sudo /vagrant/scripts/php-5.sh $1 $2 $3 $4
    else
        sudo /vagrant/scripts/php-7.sh $1 $2 $3 $4
    fi

fi
