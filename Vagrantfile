# -*- mode: ruby -*-
# vi: set ft=ruby :

# Config Github Settings
github_username = "fideloper"
github_repo     = "Vaprobash"
github_branch   = "master"

# Some variables
server_ip             = "192.168.33.10"
mysql_root_password   = "testing"
pgsql_root_password   = "root"

Vagrant.configure("2") do |config|

  config.vm.box = "precise64"

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: server_ip

  config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime']

  ####
  # Base Items
  ##########

  # Provision Base Packages
  config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/base.sh"

  # Provision PHP
  config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/php.sh"

  # Provision Oh-My-Zsh
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/zsh.sh"

  # Provision Vim
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/vim.sh"


  ####
  # Web Servers
  ##########

  # Provision Apache Base
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/apache.sh", args: server_ip

  # Provision HHVM
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/hhvm.sh"

  # Provision Nginx Base
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/nginx.sh", args: server_ip


  ####
  # Databases
  ##########

  # Provision MySQL
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/mysql.sh", args: mysql_root_password

  # Provision PostgreSQL
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/pgsql.sh", args: pgsql_root_password


  ####
  # In-Memory Stores
  ##########

  # Install Memcached
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/memcached.sh"

  # Provision Redis (without journaling and persistence)
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/redis.sh"

  # Provision Redis (with journaling and persistence)
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/redis.sh", args: "persistent"
  # NOTE: It is safe to run this to add persistence even if originally provisioned without persistence


  ####
  # Additional Languages
  ##########

  # Install Nodejs
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/nodejs.sh", privileged: false


  ####
  # Frameworks, etc
  ##########

  # Provision Composer
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/composer.sh"

  # Provision Laravel
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/laravel.sh", args: server_ip

  # Install Yeoman
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/yeoman.sh", privileged: false

end
