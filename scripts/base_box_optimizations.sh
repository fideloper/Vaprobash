#!/bin/bash

# exit script if not run as root
if [[ $EUID -ne 0 ]]; then
    cat <<END
you need to run this script as the root user
use :privileged => true in Vagrantfile
END

    exit 0
fi

# optimize apt sources to select best mirror
perl -pi -e 's@^\s*(deb(\-src)?)\s+http://us.archive.*?\s+@\1 mirror://mirrors.ubuntu.com/mirrors.txt @g' /etc/apt/sources.list

# update repositories
apt-get update
