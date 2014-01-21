pre_install() {
    node -v > /dev/null 2>&1
    NODE_IS_INSTALLED=$?

    if ! [ $NODE_IS_INSTALLED -eq 0 ]; then
        warn "!!! Installing Yeoman failed."
        die "!!! Please make sure you have installed Node.js."
    fi
}

install() {
    npm install -g yo
}
