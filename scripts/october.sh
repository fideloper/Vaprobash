#!/usr/bin/env bash

echo ">>> Installing October"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

[[ $HHVM_IS_INSTALLED -ne 0 && $PHP_IS_INSTALLED -ne 0 ]] && { printf "!!! PHP/HHVM is not installed.\n    Installing October aborted!\n"; exit 0; }

# Test if Composer is installed
composer -v > /dev/null 2>&1 || { printf "!!! Composer is not installed.\n    Installing October aborted!"; exit 0; }

# Test if Server IP is set in Vagrantfile
[[ -z "$1" ]] && { printf "!!! IP address not set. Check the Vagrantfile.\n    Installing October aborted!\n"; exit 0; }

# Check if October root is set. If not set use default
if [[ -z $2 ]]; then
    october_root_folder="/vagrant/october"
else
    october_root_folder="$2"
fi

# Test if Apache or Nginx is installed
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Create October folder if needed
if [[ ! -d $october_root_folder ]]; then
    mkdir -p $october_root_folder
fi

if [[ ! -f "$october_root_folder/composer.json" ]]; then
    if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
        # Create October
        if [[ "$4" == 'latest-stable' ]]; then
            hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer \
            create-project --prefer-dist october/october $october_root_folder
        else
            hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer \
            create-project october/october:$4 $october_root_folder
        fi
    else
        # Create October
        if [[ "$4" == 'latest-stable' ]]; then
            composer create-project --prefer-dist october/october $october_root_folder
        else
            composer create-project october/october:$4 $october_root_folder
        fi
    fi
else
    # Go to vagrant folder
    cd $october_root_folder

    if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
        hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer \
        install --prefer-dist
    else
        composer install --prefer-dist
    fi

    # Go to the previous folder
    cd -
fi

if [[ $NGINX_IS_INSTALLED -eq 0 ]]; then
    # Change default vhost created
    sudo sed -i "s@root /vagrant@root $october_root_folder@" /etc/nginx/sites-available/vagrant
    sudo service nginx reload
fi

if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
    # Find and replace to find public_folder and replace with october_root_folder
    # Change DocumentRoot
    # Change ProxyPassMatch fcgi path
    # Change <Directory ...> path
    sudo sed -i "s@$3@$october_root_folder@" /etc/apache2/sites-available/$1.xip.io.conf


    sudo service apache2 reload
fi
