#!/usr/bin/env bash


echo ">>> Making swap space to 1G"
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

echo ">>> Updated /etc/fstab with new swap partition"
echo "/var/swap.1 swap swap defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
