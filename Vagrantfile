# -*- mode: ruby -*-
# vi: set ft=ruby :

# Config Github Settings
github_username = "Ilyes512"
github_repo     = "Vaprobash"
github_branch   = "master"

Vagrant.configure("2") do |config|

  config.vm.box = "Ubuntu12043-64"

  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"

  config.vm.network :private_network, ip: "192.168.33.10"

  # config.vm.synced_folder "v-root", "/vagrant",
  #           id: "core",
  #           :nfs => true,
  #           :mount_options => ['nolock,vers=3,udp,noatime']

  # Provision Base Packages
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/base.sh"

  # Provision Apache Base
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/lamp.sh"

  # Provision Nginx Base
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/lemp.sh"

  # Provision MySQL
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/mysql.sh"

  # Provision PostgreSQL
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/pgsql.sh"

  # Provision Vim
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/vim.sh"

  # Provision Composer
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/composer.sh"

  # Provision Laravel
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/laravel.sh"

  # Install Memcached
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/memcached.sh"

  # Install Nodejs
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/nodejs.sh", privileged: false

  # Install Yeoman
  # config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/yeoman.sh", privileged: false

end
