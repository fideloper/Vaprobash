configure() {
    echo "What ip address would you like {$pkg_name} to use? "
    read ip_address
    vpb.pkg.config "${pkg_path}" ip_address "$ip_address"
}

install() {
    sudo apt-get install -y apache2 php5 libapache2-mod-php5
}

post_install() {
    sudo a2enmod rewrite
    curl https://gist.github.com/fideloper/2710970/raw/vhost.sh > vhost
    sudo chmod guo+x vhost
    sudo mv vhost /usr/local/bin

    # Create a virtualhost to start
    sudo vhost -s $ip_address.xip.io -d /vagrant

    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

    sudo service apache2 restart
}
