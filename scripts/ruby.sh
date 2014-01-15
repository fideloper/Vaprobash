#!/usr/bin/env bash

echo ">>> Installing Ruby (via RVM)"

\curl -L https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm
rvm requirements
rvm install ruby
rvm use ruby --default
rvm rubygems current