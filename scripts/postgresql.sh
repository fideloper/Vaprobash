#!/usr/bin/env bash

echo ">>> Installing PostgreSQL Server"

# You can change this

POSTGRE_VERSION=9.3
VAGRANT_USER=vagrant
VAGRANT_PASSWORD=vagrant

# Add PostgreSQL GPG public key
wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add PostgreSQL apt repository
sudo touch /etc/apt/sources.list.d/pgdg.list
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

# Update apt
sudo apt-get update

# Install PostgreSQL
sudo apt-get install -y postgresql-$POSTGRE_VERSION \
                        postgresql-client-$POSTGRE_VERSION \
                        postgresql-$POSTGRE_VERSION-slony1-2 \
                        php5-pgsql \
                        libpq-dev

# Create vagrant user
sudo -u postgres psql -c "CREATE USER $VAGRANT_USER WITH SUPERUSER CREATEDB ENCRYPTED PASSWORD '$VAGRANT_PASSWORD'"

# Make connections available for the outside world
sudo tee -a /etc/postgresql/9.3/main/pg_hba.conf <<-TEXT
host all all 0.0.0.0/0 md5
TEXT

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.3/main/postgresql.conf

# Restart PostgreSQL
# 
sudo service postgresql restart

