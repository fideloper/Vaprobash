#!/usr/bin/env bash

# Test if Redis is installed
redis-server --version > /dev/null 2>&1
REDIS_IS_INSTALLED=$?

if [[ $REDIS_IS_INSTALLED -ne 0 ]]; then

	echo ">>> Installing Redis"

	# Add repo for latest stable redis
	apt-add-repository -y ppa:rwky/redis

	# Install Redis
	sudo apt-get install -y redis-server

fi

# Disable case sensitivity
shopt -s nocasematch

# Persistence
if [[ ! -z $1 && $1 =~ true ]]; then

	echo ">>> Enabling Redis Persistence"

	# Redis Configuration
	sudo mkdir -p /etc/redis/conf.d

# transaction journaling - config is written, only enabled if persistence is requested
cat << EOF | sudo tee /etc/redis/conf.d/journaling.conf
appendonly yes
appendfsync everysec
EOF

	# add the config to the redis config includes
	if ! cat /etc/redis/redis.conf | grep -q "journaling.conf"; then
		sudo echo "include /etc/redis/conf.d/journaling.conf" >> /etc/redis/redis.conf
	fi

	# schedule background append rewriting
	if ! crontab -l | grep -q "redis-cli bgrewriteaof"; then
		line="*/5 * * * * /usr/bin/redis-cli bgrewriteaof > /dev/null 2>&1"
		(sudo crontab -l; echo "$line" ) | sudo crontab -
	fi

fi

# Enable case sensitivity
shopt -u nocasematch

sudo service redis-server restart
