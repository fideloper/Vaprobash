#!/usr/bin/env bash

if [ $EUID -ne 0 ]; then
    echo "You must be root: \"sudo ngxvhost\""
    exit 1
fi


# May need to run this as sudo!
# I have it in /usr/local/bin and run command 'ngxvhost' from anywhere, using sudo.

#
#   Show Usage, Output to STDERR
#
function show_usage {
cat <<- _EOF_

Create a new nginx vHost in Ubuntu Server
Assumes /etc/nginx/sites-available and /etc/nginx/sites-enabled setup used

    -d    DocumentRoot - i.e. /var/www/yoursite
    -h    Help - Show this menu.
    -s    ServerName - i.e. example.com or sub.example.com
    
_EOF_
exit 1
}


#
#   Output vHost skeleton, fill with userinput
#   To be outputted into new file
#
function create_vhost {
cat <<- _EOF_
server {
    root $DocumentRoot;
    index index.html index.htm index.php;

    # Make site accessible from http://set-ip-address.xip.io
    server_name $ServerName;

    access_log /var/log/nginx/$ServerName-access.log;
    error_log  /var/log/nginx/$ServerName-error.log error;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    # pass the PHP scripts to php5-fpm
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        # With php5-fpm:
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param LARA_ENV local; # Environment variable for Laravel
        include fastcgi_params;
    }

    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
}
_EOF_
}

#Sanity Check - are there two arguments with 2 values?
if [ $# -ne 4 ]; then
	show_usage
fi

#Parse flags
while getopts "hd:s:" OPTION; do
    case $OPTION in
        h)
            show_usage
            ;;
        d)
            DocumentRoot=$OPTARG
            ;;
        s)
            ServerName=$OPTARG
            ;;
        *)
            show_usage
            ;;
    esac
done

if [ ! -d $DocumentRoot ]; then 
    mkdir -p $DocumentRoot
    #chown USER:USER $DocumentRoot #POSSIBLE IMPLEMENTATION, new flag -u ?
fi

if [ -f "/etc/nginx/sites-available/$ServerName.conf" ]; then
    echo 'vHost already exists. Aborting'
    show_usage
else
    create_vhost > /etc/nginx/sites-available/${ServerName}.conf
    cd /etc/nginx/sites-available/ && ngxen ${ServerName}.conf #Enable site
    service nginx reload #Optional implementation
fi
