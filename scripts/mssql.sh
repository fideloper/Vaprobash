#!/usr/bin/env bash

echo ">>> Installing PHP MSSQL"

# Test if PHP is installed
php -v > /dev/null 2>&1 || { printf "!!! PHP is not installed.\n    Installing PHP MSSQL aborted!\n"; exit 0; }

sudo apt-get update

# Install PHP MSSQL
# -qq implies -y --force-yes
sudo apt-get install -qq php5-mssql

echo ">>> Installing freeTDS for MSSQL"

# Install freetds
sudo apt-get install -qq freetds-dev freetds-bin tdsodbc

echo ">>> Installing UnixODBC for MSSQL"

# Install unixodbc
sudo apt-get install -qq unixodbc unixodbc-dev

# Restart php5-fpm
sudo service php5-fpm restart