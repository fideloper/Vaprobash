#!/usr/bin/env bash

## Show the usage for NGXEN
function show_usage {
cat <<EOF

NGXEN:
Enable an nginx server block (Ubuntu Server).
Assumes /etc/nginx/sites-available and /etc/nginx/sites-enabled setup used.

    -q    "quiet", do not reload nginx server after operation 
    -h    Help - Show this menu.

EOF
}

if [[ $EUID -ne 0 ]]; then
    echo "!!! Please use \"sudo ngxen [Your_Server_Block]\""
    exit 1
fi

# parse options
NoReload=0
while getopts "qh" OPTION; do
    case $OPTION in
        q)
            NoReload=1
            ;;
        h)
            show_usage
            exit 0
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
done

shift $(( OPTIND - 1 ))

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

            # Reload nginx configuration
            if [[ $NoReload -eq 0 ]]; then
                service nginx reload
            fi

            exit 0
        fi
    fi
fi