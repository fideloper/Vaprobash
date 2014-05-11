#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "!!! Please use \"sudo ngxdis [Your_Server_Block]\""
    exit 1
fi

# -z str: Returns True if the length of str is equal to zero.
if [[ -z $1 ]]; then
    echo "!!! Please choose a Server Block"
    exit 1
else
    # -h filename: True if file exists and is a symbolic link.
    # -f filename: Returns True if file, filename is an ordinary file.
    if [[ ! -h /etc/nginx/sites-enabled/$1  &&  ! -f /etc/nginx/sites-enabled/$1 ]]; then
        echo "!!! Server Block \"$1\" is not enabled"
        exit 1
    else
        rm /etc/nginx/sites-enabled/$1
        echo ">>> Disabled Server Block \"$1\""
    fi
fi