#!/bin/bash

echo '### Phalcon php extension ###'

# Get su permission
sudo su

srcdir=`mktemp --tmpdir -d cphalcon.XXXXXX`

# Clone the repo
git clone --depth=1 https://github.com/phalcon/cphalcon.git ${srcdir}
cd ${srcdir}

# Get our HEADs to test is an update is necessary
touch /var/phalcon-head
INSTALLED_HEAD=$(cat /var/phalcon-head)
REPO_HEAD=$(cat .git/refs/heads/master)

if [ "$INSTALLED_HEAD" == "$REPO_HEAD" ]; then
    # Nothing to do here
    echo
    echo 'PHP extension for Phalcon is up to date'
    echo
else
    # Install/Update Phalcon
    echo
    echo 'Building Phalcon'
    echo

    # Run build script
    cd build
    ./install
    wait

    # write ini config
    if ! (php --ri phalcon &>/dev/null); then
        if [ -d "/etc/php.d" ]; then #centos, etc
            echo 'extension=phalcon.so' > /etc/php.d/phalcon.ini
        elif [ -d "/etc/php5/mods-available" ]; then #debian-like
            echo 'extension=phalcon.so' > /etc/php5/mods-available/phalcon.ini
            [ -d '/etc/php5/cli' ] && ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/cli/conf.d/phalcon.ini
            [ -d '/etc/php5/apache' ] && ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/apache/conf.d/phalcon.ini
            [ -d '/etc/php5/fpm' ] && ln -s /etc/php5/mods-available/phalcon.ini /etc/php5/fpm/conf.d/phalcon.ini
        elif [ -d "/etc/php5/conf.d" ]; then #debian-like old way
            echo 'extension=phalcon.so' > /etc/php5/conf.d/phalcon.ini
        else
            echo 'Warning: can not find php modules config dir. You should write phalcon.ini manually' >&2
        fi
    fi

    # Restart apache or php5-fpm and nginx
    echo
    echo 'Restarting web services'
    echo
    service php5-fpm status &>/dev/null && service php5-fpm restart
    service php-fpm status &>/dev/null && service php-fpm restart
    service nginx status &>/dev/null && service nginx restart
    service apache status &>/dev/null && service apache restart
    service apache2 status &>/dev/null && service apache2 restart
    service httpd status &>/dev/null && service httpd restart

    # Update the file that contains the installed HEAD
    cd ../
    cat .git/refs/heads/master > /var/phalcon-head

    echo
    echo 'PHP extension for Phalcon has been updated'
    echo
fi

rm -rf ${srcdir}

# Clean up
exit