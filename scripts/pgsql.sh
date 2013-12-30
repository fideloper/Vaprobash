#!/usr/bin/env bash

echo ">>> Installing PostgreSQL"

# Install PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib


# Configure PostgreSQL

# Listen for localhost connections
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.1/main/postgresql.conf

# Identify users via "md5", rather than "ident", allowing us
# to make PG users separate from system users. "md5" lets us
# simply use a password 
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/9.1/main/pg_hba.conf
sudo service postgresql start

# Create new user "root" w/ password "root"
# Not a superuser, just tied to new db "vagrant"
sudo -u postgres psql -c "CREATE ROLE root LOGIN UNENCRYPTED PASSWORD 'root' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

# Create new database "vagrant"
# and assign user "root"
sudo -u postgres /usr/bin/createdb --echo --owner=root vagrant

# Make sure changes are reflected by restarting
sudo service postgresql restart
