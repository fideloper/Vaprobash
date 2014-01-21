configure() {
    echo "What version of ${pkg_name} do you want installed? "
    read answer
    vpb.pkg.config ${pkg_path} ruby_version "$answer"
}

pre_install() {
    # Check if RVM is installed
    RVM -v > /dev/null 2>&1
    RVM_IS_INSTALLED=$?
}

install() {
    if [[ $RVM_IS_INSTALLED -eq 0 ]]; then
        rvm get stable --ignore-dotfiles
    else
        # Install RVM and install Ruby
        if [[ -z $ruby_version || $ruby_version -eq "latest" ]]; then

            # Install RVM and install latest stable Ruby version
            \curl -sSL https://get.rvm.io | bash -s stable --ruby
        else

            # Install RVM and install selected Ruby version
            \curl -sSL https://get.rvm.io | bash -s stable --ruby=$ruby_version
        fi
    fi
}

post_install() {
    # Re-source .bash_profile, .zshrc or .bashrc if they exist
    if [[ -f "/home/vagrant/.bash_profile" ]]; then
        . /home/vagrant/.bash_profile
    fi

    if [[ -f "/home/vagrant/.zshrc" ]]; then
        . /home/vagrant/.zshrc
    fi

    if [[ -f "/home/vagrant/.bashrc" ]]; then
        . /home/vagrant/.bashrc
    fi
}
