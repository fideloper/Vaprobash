---
layout: default
title: Vagrantfile
---

The Vagrantfile has a few variable and assumptions which need explanation.

## GitHub Settings

```ruby
github_username = "fideloper"
github_repo     = "Vaprobash"
github_branch   = "master"
```

These are the user, repository and branch from which the shell scripts are downloaded when provisioning. This is handy if you have scripts from other repositories or branches. I use it to change scripts to the "develop" branch when I'm testing new ones.

## Variables

```ruby
server_ip             = "192.168.33.10"
server_cpus           = "1"   # Cores
server_memory         = "384" # MB
server_swap           = "768" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

mysql_root_password   = "root" # We'll assume user "root"
pgsql_root_password   = "root" # We'll assume user "root"
```

These variables are used throughout various install scripts. The IP address is a static IP address assigned to the virtual machine. Some scripts need this IP address for their configurations. Note that while we assume a user of "root" for any database, we can configure their passwords here.

## Box and Network

```ruby
# Set server to Ubuntu 12.04
config.vm.box = "ubuntu/trusty64"

# Create a static IP
config.vm.network :private_network, ip: server_ip
```

We use Ubuntu Server LTS releases. Currently, this is Ubuntu 14.04. For network settings, we set the static IP address as defined above.

## NFS

```ruby
config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime']
```

Because the default file sync can have speed issues with large amounts of files, this repository defaults to setting up a Network File System to share files between the host system and the virtual machine.

## Memory and CPUs

```ruby
# Set server cpus
vb.customize ["modifyvm", :id, "--cpus", server_cpus]

# Set server memory
vb.customize ["modifyvm", :id, "--memory", server_memory]
```

We can set how much memory is allocated to the VM both values are set above in the "variables" section.

## Scripts

The remaining items are various scripts which we can comment or uncomment in order to use. These will grab the shell scripts from Git and use them to install the various items onto your virtual machine during Vagrant's provisioning process.
