#!/usr/bin/env bash

echo ">>> Installing Laravel"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

[[ $HHVM_IS_INSTALLED -ne 0 && $PHP_IS_INSTALLED -ne 0 ]] && { printf "!!! PHP/HHVM is not installed.\n    Installing Laravel aborted!\n"; exit 0; }

# Test if Composer is installed
composer -v > /dev/null 2>&1 || { printf "!!! Composer is not installed.\n    Installing Laravel aborted!"; exit 0; }

# Test if Server Name is set in Vagrantfile
[[ -z "$1" ]] && { printf "!!! Server name address not set. Check the Vagrantfile.\n    Installing Laravel aborted!\n"; exit 0; }

# Check if Laravel root is set. If not set use default
if [[ -z $laravel_root_folder ]]; then
    laravel_root_folder="/var/www/laravel-test"
else
    laravel_root_folder="$laravel_root_folder"
fi

laravel_public_folder="$laravel_root_folder/public"

# Test if Apache or Nginx is installed
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Create Laravel folder if needed
if [[ ! -d $laravel_root_folder ]]; then
    mkdir -p $laravel_root_folder
fi

if [[ ! -f "$laravel_root_folder/composer.json" ]]; then
    if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
        # Create Laravel
        if [[ "$4" == 'latest-stable' ]]; then
            hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer \
            create-project --prefer-dist laravel/laravel $laravel_root_folder
        else
            hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer \
            create-project laravel/laravel:$laravel_version $laravel_root_folder
        fi
    else
        # Create Laravel
        if [[ "$laravel_version" == 'latest-stable' ]]; then
            composer create-project --prefer-dist laravel/laravel $laravel_root_folder
        else
            composer create-project laravel/laravel:$laravel_version $laravel_root_folder
        fi
    fi
else
    # Go to ubuntu folder
    cd $laravel_root_folder

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
    sudo sed -i "s@root /ubuntu@root $laravel_public_folder@" /etc/nginx/sites-available/$laravel_server_name
    sudo service nginx reload
fi

if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then

    # Make Laravel storage folder readable and writeable, 
    # and accessable by Apache.
    chown -R www-data:www-data $laravel_root_folder/storage
    chmod -R 755 $laravel_root_folder/storage
	
    sudo vhost -s $laravel_server_name -a $laravel_alias -d $laravel_public_folder

    sudo service apache2 restart
fi
