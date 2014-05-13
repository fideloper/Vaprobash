#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "!!! Please use \"sudo ngxen [Your_Server_Block]\""
    exit 1
fi

# -z str: Returns True if the length of str is equal to zero.
if [[ -z $1 ]]; then
    echo "!!! Please choose a Server Block"
    exit 1
else
    # -h filename: True if file exists and is a symbolic link.
    # -f filename: Returns True if file, filename is an ordinary file.
    if [[ -h /etc/nginx/sites-enabled/$1 || -f /etc/nginx/sites-enabled/$1 ]]; then
        echo "!!! Server Block \"$1\" is already enabled"
        exit 1
    else
        if [[ ! -f /etc/nginx/sites-available/$1 ]]; then
            echo "!!! Server Block \"$1\" does not exist in \"/etc/nginx/sites-available\""
            exit 1
        else
            ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/$1
            echo ">>> Enabled Server Block \"$1\""
            exit 0
        fi
    fi
fi