#!/usr/bin/env bash

echo ">>> Installing Oracle Java 8"

# Install Oracle Java 8
add-apt-repository ppa:webupd8team/java
apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install -qq oracle-java8-installer >> /dev/null 2>&1
