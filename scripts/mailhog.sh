#!/usr/bin/env bash

echo ">>> Installing Mailhog"

# Download binary from github
wget --quiet -O ~/mailhog https://github.com/mailhog/MailHog/releases/download/v0.1.3/MailHog_linux_amd64

# Make it executable
chmod +x ~/mailhog

# Make it start on reboot
sudo tee /etc/init/mailhog.conf <<EOL
description "Mailhog"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

pre-start script
	exec su - vagrant -c "/usr/bin/env ~/mailhog > /dev/null 2>&1 &"
end script
EOL

# Start it now
sudo service mailhog start
