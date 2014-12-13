#!/usr/bin/env bash

echo ">>> Installing Elasticsearch"

# Set some variables
ELASTICSEARCH_VERSION=1.0.0 # Check http://www.elasticsearch.org/download/ for latest version

# Install prerequisite: Java
# -qq implies -y --force-yes
sudo apt-get install -qq openjdk-7-jre-headless

wget --quiet https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.deb
sudo dpkg -i elasticsearch-$ELASTICSEARCH_VERSION.deb
rm elasticsearch-$ELASTICSEARCH_VERSION.deb

# Configure Elasticsearch for development purposes (1 shard/no replicas, don't allow it to swap at all if it can run without swapping)
sudo sed -i "s/# index.number_of_shards: 1/index.number_of_shards: 1/" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/# index.number_of_replicas: 0/index.number_of_replicas: 0/" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/# bootstrap.mlockall: true/bootstrap.mlockall: true/" /etc/elasticsearch/elasticsearch.yml
sudo service elasticsearch restart

# Configure to start up Elasticsearch automatically
sudo update-rc.d elasticsearch defaults 95 10
