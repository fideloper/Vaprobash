#!/usr/bin/env bash

echo ">>> Installing PostgreSQL"

# Install PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib

# Configure PostgreSQL
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.1/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/9.1/main/pg_hba.conf
sudo service postgresql start
sudo -u postgres psql -c "CREATE ROLE root LOGIN UNENCRYPTED PASSWORD 'root' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
sudo -u postgres /usr/bin/createdb --echo --owner=root vagrant
sudo service postgresql restart
