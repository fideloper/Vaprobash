install() {
    sudo apt-get install couchdb -y
}

post_install() {
    sudo sed -i 's/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/' /etc/couchdb/local.ini
}
