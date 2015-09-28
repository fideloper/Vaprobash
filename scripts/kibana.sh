#!/usr/bin/env bash

echo ">>> Installing Kibana"

# Set some variables
KIBANA_VERSION=4.1.1 # Check https://www.elastic.co/downloads/kibana for latest version

sudo mkdir -p /opt/kibana
wget --quiet https://download.elastic.co/kibana/kibana/kibana-$KIBANA_VERSION-linux-x64.tar.gz
sudo tar xvf kibana-$KIBANA_VERSION-linux-x64.tar.gz -C /opt/kibana --strip-components=1
rm kibana-$KIBANA_VERSION-linux-x64.tar.gz

# Configure to start up Kibana automatically
cd /etc/init.d && sudo wget --quiet https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4

sudo chmod +x /etc/init.d/kibana4
sudo update-rc.d kibana4 defaults 95 10
sudo service kibana4 start
