configure() {
    echo "What version of ${pkg_name} do you want installed? "
    read answer
    vpb.pkg.config ${pkg_path} version "$answer"
}

pre_install() {
    if [ "$php_version" == "latest" ]; then
        sudo add-apt-repository -y ppa:ondrej/php5
    fi

    if [ "$php_version" == "previous" ]; then
        sudo add-apt-repository -y ppa:ondrej/php5-oldstable
    fi

    sudo apt-get update
}

install() {
    sudo apt-get install -y php5-cli php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-gmp php5-mcrypt php5-xdebug php5-memcached php5-imagick
}

post_install() {
    # xdebug Config
    cat > /etc/php5/mods-available/xdebug.ini << EOF
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF
}
