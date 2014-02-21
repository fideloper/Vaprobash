#!/usr/bin/env bash
#
#
echo ">>> Installing PHP MSSQL"

sudo apt-get update


# Install PHP MSSQL
sudo apt-get install -y php5-mssql

echo ">>> Installing freeTDS for MSSQL"

# Install freetds
sudo apt-get install -y freetds-dev freetds-bin tdsodbc

echo ">>> Installing UnixODBC for MSSQL"

# Install unixodbc
sudo apt-get install -y unixodbc unixodbc-dev

sudo service php5-fpm restart
