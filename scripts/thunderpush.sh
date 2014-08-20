#!/bin/bash
# This script will install https://github.com/thunderpush/thunderpush , in your vagrant instance. 

set -e
if [ -e /.installed ]; then
    echo 'Thunderpush is , already installed.'
else
    echo ''
    git clone https://github.com/gayanhewa/thunderpush.git .thunderpush
    cd  .thunderpush
    sudo apt-get update
    sudo apt-get -y install tmux make python-setuptools python-dev python-pip
    python setup.py develop
    touch /.installed
fi
