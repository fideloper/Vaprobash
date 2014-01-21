install() {
    sudo apt-get install -y beanstalkd
}

post_install() {
    # Set to start on system start
    sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd

    # Start Beanstalkd
    sudo service beanstalkd start
}
