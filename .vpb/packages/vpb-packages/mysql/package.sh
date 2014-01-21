configure() {
    echo "Do you want to install version 5.6 of ${pkg_name} (y/n) ? "
    read answer
    case $answer in
        y)
            vpb.pkg.config ${pkg_path} mysql_version "5.6"
            ;;
        *)
            vpb.pkg.config ${pkg_path} mysql_version "current"
            ;;
    esac

    echo "What root passowrd do you want to set for ${pkg_name} ? "
    read answer
    vpb.pkg.config ${pkg_path} mysql_root_password "$answer"
}

pre_install() {
    mysql_package=mysql-server

    if [ "$mysql_version" == "5.6" ]; then
        # Add repo for MySQL 5.6
        sudo add-apt-repository -y ppa:ondrej/mysql-5.6

        # Update Again
        sudo apt-get update

        # Change package
        mysql_package=mysql-server-5.6
    fi
}

install() {
    # Install MySQL without password prompt
    # Set username and password to 'root'
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password:"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_password"

    # Install MySQL Server
    sudo apt-get install -y $mysql_package
}
