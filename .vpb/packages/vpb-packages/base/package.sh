pre_install() {
    sudo apt-get update
}

install() {
    sudo apt-get install -y git-core ack-grep vim tmux curl wget build-essential python-software-properties
}

post_install() {
    curl https://gist.github.com/fideloper/3751524/raw/.gitconfig > /home/vagrant/.gitconfig
    sudo chown vagrant:vagrant /home/vagrant/.gitconfig
}
