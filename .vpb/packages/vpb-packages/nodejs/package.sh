configure() {
    echo "What version of ${pkg_name} do you want installed? "
    read answer
    vpb.pkg.config ${pkg_path} version "$answer"
}

install() {
    # Install NVM
    # TODO: Create own nvm install.sh. (add nvm execution to both .bash_profile and .zshrc)
    curl https://raw.github.com/creationix/nvm/master/install.sh | sh
}

post_install() {
    if [ ! -f "$HOME/.bash_profile" ]; then
        echo > ~/.bash_profile
    fi

    # Which version of Node.js do you wish to install?
    NODEJS_VERSION=$version

    # If set to latest, get the current node version from the home page
    if [ "$NODEJS_VERSION" == "latest" ]; then
        NODEJS_VERSION=`curl 'nodejs.org' | grep 'Current Version' | awk '{ print $3 }' | awk -F\< '{ print $1 }'`
    fi

    # Reload .bash_profile and/or .zshrc if they exist
    if [ -f "$HOME/.bash_profile" ]; then
        . ~/.bash_profile
    fi

    if [ -f "$HOME/.zshrc" ]; then
        . ~/.zshrc
    fi

    # Install Node
    nvm install $NODEJS_VERSION

    # Set a default node version and start using it
    nvm alias default $NODEJS_VERSION

    nvm use default

    # Change where npm global packages location
    npm config set prefix ~/npm

    # Add new npm global packages location to PATH
    printf "\n# Add new npm global packages location to PATH\n%s" 'export PATH=$PATH:~/npm/bin' >> ~/.bash_profile

    # Add new npm root to NODE_PATH
    printf "\n# Add the new npm root to NODE_PATH\n%s" 'export NODE_PATH=$NODE_PATH:~/npm/lib/node_modules' >> ~/.bash_profile
}
