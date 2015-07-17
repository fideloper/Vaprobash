#!/usr/bin/env bash

echo ">>> Installing Percona MySQL Server $2"

[[ -z "$1" ]] && { echo "!!! MySQL root password not set. Check the Vagrant file."; exit 1; }

#mysql_package=mysql-server
mysql_package=percona-server

# Check if percona source list
if [ -e /etc/apt/sources.list.d/percona.list ]; then
  echo "Percona repo already installed"
else
  echo "Installing Percona repo ..."
  sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

  # Could use Distro Release?
  cat << EOF | sudo tee /etc/apt/sources.list.d/percona.list
# http://www.percona.com/doc/percona-server/5.6/installation/apt_repo.html
deb http://repo.percona.com/apt trusty main
deb-src http://repo.percona.com/apt trusty main
EOF

	# Update Again
	sudo apt-get update

fi

# Check if a version is supplied
if [ -z $2 ];then
  # Default package version - Not Tested
  # Install MySQL without password prompt
  # Set username and password to 'root'
  #sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
  #sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"
  sudo debconf-set-selections <<< "percona-server-server percona-server-server/root_password password $1"
  sudo debconf-set-selections <<< "percona-server-server percona-server-server/root_password_again password $1"

  # Install MySQL Server
  # -qq implies -y --force-yes
  sudo apt-get install -qq $mysql_package-server $mysql_package-client
else
  # With a version 5.5/5.6

  # Install MySQL without password prompt
  # Set username and password to 'root'
  sudo debconf-set-selections <<< "percona-server-server-$2 percona-server-server/root_password password $1"
  sudo debconf-set-selections <<< "percona-server-server-$2 percona-server-server/root_password_again password $1"

  # Install MySQL Server
  # -qq implies -y --force-yes
  sudo apt-get install -qq $mysql_package-server-$2 $mysql_package-client-$2
fi

# Make MySQL connectable from outside world without SSH tunnel
if [ $3 == "true" ]; then
    # enable remote access
    # setting the mysql bind-address to allow connections from everywhere
    sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

    # adding grant privileges to mysql root user from everywhere
    # thx to http://stackoverflow.com/questions/7528967/how-to-grant-mysql-privileges-in-a-bash-script for this
    MYSQL=`which mysql`

    Q1="GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$1' WITH GRANT OPTION;"
    Q2="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}"

    $MYSQL -uroot -p$1 -e "$SQL"

    service mysql restart
fi
