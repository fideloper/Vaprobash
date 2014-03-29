#!/usr/bin/env bash

# https://launchpad.net/~builds/+archive/sphinxsearch-stable
# sudo add-apt-repository -y ppa:builds/sphinxsearch-stable # 2.0.11 on Precise

# https://launchpad.net/~builds/+archive/sphinxsearch-daily
# sudo add-apt-repository -y ppa:builds/sphinxsearch-daily  # 2.2.* on Precise

# https://launchpad.net/~builds/+archive/sphinxsearch-beta
sudo add-apt-repository -y ppa:builds/sphinxsearch-beta     # 2.1.*  on Precise

# The usual updates
sudo apt-get update

# Install SphinxSearch
sudo apt-get install sphinxsearch

# Create a base conf file (Altho we can't make any assumptions about its use)
