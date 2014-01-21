pre_install() {
    # Get key and add to sources
    wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
    echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list

    # Update
    sudo apt-get update
}

install() {
    sudo apt-get -y install hhvm
}
