configure() {
    echo "What ip address to you want to run ${pkg_name} on? "
    read answer
    vpb.pkg.config ${pkg_path} ip_address "$answer"
}

post_install() {
    # Test if Composer is installed
    composer --version > /dev/null 2>&1
    COMPOSER_IS_INSTALLED=$?

    if [ $COMPOSER_IS_INSTALLED -gt 0 ]; then
        die "ERROR: Laravel install requires composer"
    fi

    hhvm --version > /dev/null 2>&1
    HHVM_IS_INSTALLED=$?

    nginx -v > /dev/null 2>&1
    NGINX_IS_INSTALLED=$?

    apache2 -v > /dev/null 2>&1
    APACHE_IS_INSTALLED=$?
}

install() {
    # Create Laravel
    if [ $HHVM_IS_INSTALLED -eq 0 ]; then
        hhvm /usr/local/bin/composer create-project --prefer-dist laravel/laravel /vagrant/laravel
    else
        composer create-project --prefer-dist laravel/laravel /vagrant/laravel
    fi
}

post_install() {
    if [ $NGINX_IS_INSTALLED -eq 0 ]; then
        # Change default vhost created
        sed -i "s/root \/vagrant/root \/vagrant\/laravel\/public/" /etc/nginx/sites-available/vagrant
        sudo service nginx reload
    fi

    if [ $APACHE_IS_INSTALLED -eq 0 ]; then
        # Remove apache vhost from default and create a new one
        rm /etc/apache2/sites-enabled/$1.xip.io.conf > /dev/null 2>&1
        rm /etc/apache2/sites-available/$1.xip.io.conf > /dev/null 2>&1
        vhost -s $1.xip.io -d /vagrant/laravel/public
        sudo service apache2 reload
    fi
}
