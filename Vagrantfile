# -*- mode: ruby -*-
# vi: set ft=ruby :

# Config Github Settings
#github_username = "rattfieldnz"
#github_repo     = "Vaprobash"
#github_branch   = "1.4.3"
#github_url      = "https://raw.githubusercontent.com/#{github_username}/#{github_repo}/#{github_branch}"
github_url=""

vm_synced_folder_host  = "code"
vm_synced_folder_guest = "/home/ubuntu"

# Because this:https://developer.github.com/changes/2014-12-08-removing-authorizations-token/
# https://github.com/settings/tokens
github_pat          = ""

# Server Configuration

hostname        = "vaprobash.dev"

# Set a local private network IP address.
# See http://en.wikipedia.org/wiki/Private_network for explanation
# You can use the following IP ranges:
#   10.0.0.1    - 10.255.255.254
#   172.16.0.1  - 172.31.255.254
#   192.168.0.1 - 192.168.255.254
server_ip             = "192.168.22.10"
server_cpus           = "4"   # Cores
server_memory         = "4096" # MB
server_swap           = "8192" # Options: false | int (MB) - Guideline: Between one or two times the server_memory
disk_space            = "25GB"

# UTC        for Universal Coordinated Time
# EST        for Eastern Standard Time
# CET        for Central European Time
# US/Central for American Central
# US/Eastern for American Eastern
server_timezone  = "Pacific/Auckland"

# Database Configuration
mysql_root_password   = "root"   # We'll assume user "root"
mysql_version         = "5.7"    # Options: 5.5 | 5.6 | 5.7
mysql_enable_remote   = "false"  # remote access enabled when true
pgsql_root_password   = "root"   # We'll assume user "root"
mongo_version         = "3.2"    # Options: 2.6 | 3.0 | 3.2
mongo_enable_remote   = "false"  # remote access enabled when true

# Languages and Packages
php_timezone          = "Pacific/Auckland"    # http://php.net/manual/en/timezones.php
php_version           = "7.1"    # Options: 5.5 | 5.6 | 7.0 | 7.1
ruby_version          = "latest" # Choose what ruby version should be installed (will also be the default version)
ruby_gems             = [        # List any Ruby Gems that you want to install
  "sass",
  "compass",
  "capistrano",
  "capistrano-laravel"
]

go_version            = "latest" # Example: go1.4 (latest equals the latest stable version)

# To install HHVM instead of PHP, set this to "true"
hhvm                  = "false"

# PHP Options
composer_packages     = [        # List any global Composer packages that you want to install
  "phpunit/phpunit:~6.4",
  "phpunit/php-invoker:^1.1",
  "codeception/codeception:~2.3",
  "phpspec/phpspec:~4.2",
  "squizlabs/php_codesniffer:^3.0",
  "unitgen/unitgen:dev-master",
  "theseer/phpdox:^0.1"
]

# Default web server document root
# Symfony's public directory is assumed "web"
# Laravel's public directory is assumed "public"
public_folder         = "/home/ubuntu/code"

laravel_root_folder   = "#{public_folder}/laravel-test" # Where to install Laravel. Will `composer install` if a composer.json file exists
laravel_version       = "latest-stable" # If you need a specific version of Laravel, set it here
symfony_root_folder   = "#{public_folder}/code/symfony-test" # Where to install Symfony.

nodejs_version        = "latest"   # By default "latest" will equal the latest stable version
nodejs_packages       = [          # List any global NodeJS packages that you want to install
  "grunt-cli",
  "gulp",
  "bower",
  "yo",
  "gulp-concat-css",
  "gulp-minify-css",
  "gulp-rename",
  "gulp-ruby-sass",
  "gulp-sourcemaps",
  "gulp-uglify",
  "notify-send",
  "sw-precache-webpack-plugin",
  "cross-env",
  "cross-env",
  "laravel-mix"
]

# RabbitMQ settings
rabbitmq_user = "user"
rabbitmq_password = "password"

sphinxsearch_version  = "rel22" # rel20, rel21, rel22, beta, daily, stable

elasticsearch_version = "2.3.1" # 5.0.0-alpha1, 2.3.1, 2.2.2, 2.1.2, 1.7.5

Vagrant.configure("2") do |config|

  # Set server to Ubuntu 16.04
  config.vm.box = "ubuntu/xenial64"

  config.vm.define "Vaprobash" do |vapro|
  end

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = false
  end

  # Create a hostname, don't forget to put it to the `hosts` file
  # This will point to the server's default virtual host
  # TO DO: Make this work with virtualhost along-side xip.io URL
  config.vm.hostname = hostname

  # Create a static IP
  if Vagrant.has_plugin?("vagrant-auto_network")
    config.vm.network :private_network, :ip => "0.0.0.0", :auto_network => true
  else
    config.vm.network :private_network, ip: server_ip
    config.vm.network :forwarded_port, guest: 80, host: 8000
  end

  # Enable agent forwarding over SSH connections
  config.ssh.forward_agent = true

  # Use NFS for the shared folder
  #config.vm.synced_folder vm_synced_folder_host, vm_synced_folder_guest
  #  id: "core"
  #  :nfs => true,
  #  :mount_options => ['nolock,vers=3,udp,noatime,actimeo=2,fsc']

  # Replicate local .gitconfig file if it exists
  if File.file?(File.expand_path("~/.gitconfig"))
    config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
  end

  # If using VirtualBox
  config.vm.provider :virtualbox do |vb|

    vb.name = hostname

    # Set server cpus
    vb.customize ["modifyvm", :id, "--cpus", server_cpus]

    # Set server memory
    vb.customize ["modifyvm", :id, "--memory", server_memory]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

    # Prevent VMs running on Ubuntu to lose internet connection
    # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	
	# Set initial disk size
	if Vagrant.has_plugin?("vagrant-disksize")
	    config.disksize.size = "#{disk_space}"
	end	

  end

  # If using VMWare Fusion
  #config.vm.provider "vmware_fusion" do |vb, override|
  #  override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
  #
  ## Set server memory
  #  vb.vmx["memsize"] = server_memory
  #
  #end

  # If using Vagrant-Cachier
  # http://fgrehm.viewdocs.io/vagrant-cachier
  #if Vagrant.has_plugin?("vagrant-cachier")
  #  # Configure cached packages to be shared between instances of the same base box.
  #  # Usage docs: http://fgrehm.viewdocs.io/vagrant-cachier/usage
  #  config.cache.scope = :box
  #
  #  config.cache.synced_folder_opts = {
  #      type: :nfs,
  #      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
  #  }
  #end

  # Adding vagrant-digitalocean provider - https://github.com/smdahlen/vagrant-digitalocean
  # Needs to ensure that the vagrant plugin is installed
  #config.vm.provider :digital_ocean do |provider, override|
  #  override.ssh.private_key_path = '~/.ssh/id_rsa'
  #  override.ssh.username = 'ubuntu'
  #  override.vm.box = 'digital_ocean'
  #  override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
  #
  #  provider.token = 'YOUR TOKEN'
  #  provider.image = 'ubuntu-14-04-x64'
  #  provider.region = 'nyc2'
  #  provider.size = '512mb'
  #end

  ####
  # Base Items
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Provision Base Packages
  config.vm.provision "shell", path: "./scripts/base.sh", privileged: true, args: [github_url, server_swap, server_timezone]

  # optimize base box
  config.vm.provision "shell", path: "./scripts/base_box_optimizations.sh", privileged: true

  # Provision PHP
  config.vm.provision "shell", path: "./scripts/php.sh", args: [php_timezone, hhvm, php_version]

  # Enable MSSQL for PHP
  # config.vm.provision "shell", path: "./scripts/mssql.sh"

  # Provision Vim
  config.vm.provision "shell", path: "./scripts/vim.sh", args: github_url

  # Provision Docker
  # config.vm.provision "shell", path: "./scripts/docker.sh", args: "permissions"

  ####
  # Web Servers
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Provision Apache Base
  config.vm.provision "shell", path: "./scripts/apache.sh", args: [server_ip, public_folder, hostname, github_url]

  # Provision Nginx Base
  # config.vm.provision "shell", path: "#{github_url}/scripts/nginx.sh", args: [server_ip, public_folder, hostname, github_url, php_version]


  ####
  # Databases
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Provision MySQL
  config.vm.provision "shell", path: "./scripts/mysql.sh", args: [mysql_root_password, mysql_version, mysql_enable_remote]

  # Provision PostgreSQL
  config.vm.provision "shell", path: "./scripts/pgsql.sh", args: pgsql_root_password

  # Provision SQLite
  config.vm.provision "shell", path: "./scripts/sqlite.sh"

  # Provision RethinkDB
  # config.vm.provision "shell", path: "#{github_url}/scripts/rethinkdb.sh", args: pgsql_root_password

  # Provision Couchbase
  # config.vm.provision "shell", path: "#{github_url}/scripts/couchbase.sh", args: [php_version]

  # Provision CouchDB
  # config.vm.provision "shell", path: "#{github_url}/scripts/couchdb.sh"

  # Provision MongoDB
  config.vm.provision "shell", path: "./scripts/mongodb.sh", args: [mongo_enable_remote, mongo_version]

  # Provision MariaDB
  # config.vm.provision "shell", path: "./scripts/mariadb.sh", args: [mysql_root_password, mysql_enable_remote]

  # Provision Neo4J
  # config.vm.provision "shell", path: "./scripts/neo4j.sh"

  ####
  # Search Servers
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Install Elasticsearch
  # config.vm.provision "shell", path: "./scripts/elasticsearch.sh", args: [elasticsearch_version]

  # Install SphinxSearch
  # config.vm.provision "shell", path: "./scripts/sphinxsearch.sh", args: [sphinxsearch_version]

  ####
  # Search Server Administration (web-based)
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Install ElasticHQ
  # Admin for: Elasticsearch
  # Works on: Apache2, Nginx
  # config.vm.provision "shell", path: "./scripts/elastichq.sh"


  ####
  # In-Memory Stores
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Install Memcached
  config.vm.provision "shell", path: "./scripts/memcached.sh"

  # Provision Redis (without journaling and persistence)
  # config.vm.provision "shell", path: "#{github_url}/scripts/redis.sh"

  # Provision Redis (with journaling and persistence)
  config.vm.provision "shell", path: "./scripts/redis.sh", args: "persistent"
  # NOTE: It is safe to run this to add persistence even if originally provisioned without persistence


  ####
  # Utility (queue)
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Install Beanstalkd
  # config.vm.provision "shell", path: "./scripts/beanstalkd.sh"

  # Install Heroku Toolbelt
  # config.vm.provision "shell", path: "https://toolbelt.heroku.com/install-ubuntu.sh"

  # Install Supervisord
  # config.vm.provision "shell", path: "./scripts/supervisord.sh"

  # Install Kibana
  # config.vm.provision "shell", path: "./scripts/kibana.sh"

  # Install ØMQ
  # config.vm.provision "shell", path: "./scripts/zeromq.sh", args: [php_version]

  # Install RabbitMQ
  # config.vm.provision "shell", path: "./scripts/rabbitmq.sh", args: [rabbitmq_user, rabbitmq_password]

  ####
  # Additional Languages
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Install Nodejs
  config.vm.provision "shell", path: "./scripts/nodejs.sh", privileged: false, args: nodejs_packages.unshift(nodejs_version, github_url)

  # Install Ruby Version Manager (RVM)
  config.vm.provision "shell", path: "./scripts/rvm.sh", privileged: false, args: ruby_gems.unshift(ruby_version)

  # Install Go Version Manager (GVM)
  # config.vm.provision "shell", path: "./scripts/go.sh", privileged: false, args: [go_version]

  ####
  # Frameworks and Tooling
  #
  # NOTE!: Comment out lines for scripts you don't want to run!
  ##########

  # Provision Composer
  # You may pass a github auth token as the first argument
  config.vm.provision "shell", path: "./scripts/composer.sh", privileged: false, args: [github_pat, composer_packages.join(" ")]

  # Provision Laravel
  config.vm.provision "shell", path: "./scripts/laravel.sh", privileged: false, args: [server_ip, laravel_root_folder, public_folder, laravel_version]

  # Provision Symfony
  config.vm.provision "shell", path: "./scripts/symfony.sh", privileged: false, args: [server_ip, symfony_root_folder, public_folder]

  # Install Screen
  config.vm.provision "shell", path: "./scripts/screen.sh"

  # Install Mailcatcher
  config.vm.provision "shell", path: "./scripts/mailcatcher.sh", args: [php_version]

  # Install git-ftp
  # config.vm.provision "shell", path: "./scripts/git-ftp.sh", privileged: false

  # Install Ansible
  # config.vm.provision "shell", path: "./scripts/ansible.sh"

  # Install Android
  # config.vm.provision "shell", path: "./scripts/android.sh"

  ####
  # Local Scripts
  # Any local scripts you may want to run post-provisioning.
  # Add these to the same directory as the Vagrantfile.
  ##########
  # config.vm.provision "shell", path: "./your_script_name.sh"
  config.vm.provision "shell", path: "./scripts/install_phpmyadmin.sh"

  #####
  # Optional
  # If you want to set-up your custom projects,
  # add a bash script file (project_name.sh) in
  # the 'project_setup_scripts' directory which
  # contains the necessary functionality to set it/them up.
  #
  # The bash script referenced below will loop over
  # and execute scripts (with .sh extension) in the
  # mentioned directory.
  ##########
  config.vm.provision "shell", path: "./setup_projects.sh"

end
