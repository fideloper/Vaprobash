#!/usr/bin/env bash

if [[ $2 == "true" ]]; then

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
    echo ">>> Installing PHP"

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
    sudo add-apt-repository -y ppa:ondrej/php5

    sudo apt-key update
    sudo apt-get update

    # Install PHP
    # -qq implies -y --force-yes
    sudo apt-get install -qq php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-gmp php5-mcrypt php5-xdebug php5-memcached php5-imagick php5-intl

    # Set PHP FPM to listen on TCP instead of Socket
    sudo sed -i "s/listen =.*/listen = 127.0.0.1:9000/" /etc/php5/fpm/pool.d/www.conf

    # Set PHP FPM allowed clients IP address
    sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php5/fpm/pool.d/www.conf

    # Set run-as user for PHP5-FPM processes to user/group "vagrant"
    # to avoid permission errors from apps writing to files
    sudo sed -i "s/user = www-data/user = vagrant/" /etc/php5/fpm/pool.d/www.conf
    sudo sed -i "s/group = www-data/group = vagrant/" /etc/php5/fpm/pool.d/www.conf

    sudo sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php5/fpm/pool.d/www.conf
    sudo sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php5/fpm/pool.d/www.conf
    sudo sed -i "s/listen\.mode.*/listen.mode = 0666/" /etc/php5/fpm/pool.d/www.conf


    # xdebug Config
    cat > $(find /etc/php5 -name xdebug.ini) << EOF
zend_extension=$(find /usr/lib/php5 -name xdebug.so)
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9000
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1

; var_dump display
xdebug.var_display_max_depth = 5
xdebug.var_display_max_children = 256
xdebug.var_display_max_data = 1024
EOF

    # PHP Error Reporting Config
    sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
    sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

    # PHP Date Timezone
    sudo sed -i "s/;date.timezone =.*/date.timezone = ${2/\//\\/}/" /etc/php5/fpm/php.ini
    sudo sed -i "s/;date.timezone =.*/date.timezone = ${2/\//\\/}/" /etc/php5/cli/php.ini

    sudo service php5-fpm restart
fi
