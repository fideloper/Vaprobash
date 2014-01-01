# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "precise64"

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "192.168.33.10"
  
  config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime']

  # Provision Apache Base
  # config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/lamp.sh"

  # Provision Nginx Base
  # config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/lemp.sh"

  # Provision MySQL
  # config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/mysql.sh"
  #   config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/phpmyadmin.sh"


  # Provision PostgreSQL
  # config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/pgsql.sh"

  # Provision Vim
  # config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/vim.sh"

  # Provision Composer
  # config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/composer.sh"

  # Provision Laravel
  # config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/laravel.sh"

  # Install Memcached
  # config.vm.provision "shell", path: "https://raw.github.com/fideloper/Vaprobash/master/scripts/memcached.sh"

end
