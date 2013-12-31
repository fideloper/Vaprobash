#!/usr/bin/env bash

echo ">>> Installing PostgreSQL"

# Set some variables
POSTGRE_VERSION=9.3
POSTGRE_USER=root
POSTGRE_PASS=root

# Add PostgreSQL GPG public key
# to get latest stable
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add PostgreSQL Apt repository
# to get latest stable
sudo touch /etc/apt/sources.list.d/pgdg.list
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

# Update Apt repos
sudo apt-get update

# Install PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib


# Configure PostgreSQL

# Listen for localhost connections
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/$POSTGRE_VERSION/main/postgresql.conf

# Identify users via "md5", rather than "ident", allowing us
# to make PG users separate from system users. "md5" lets us
# simply use a password 
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/$POSTGRE_VERSION/main/pg_hba.conf
sudo service postgresql start

# Create new user "$POSTGRE_USER" w/ password "root"
# Not a superuser, just tied to new db "vagrant"
sudo -u postgres psql -c "CREATE ROLE $POSTGRE_USER LOGIN UNENCRYPTED PASSWORD '$POSTGRE_PASS' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

# Make sure changes are reflected by restarting
sudo service postgresql restart
