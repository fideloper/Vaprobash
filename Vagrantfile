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

  # Provision LAMP
  # config.vm.provision "shell", path: "https://gist.github.com/fideloper/7074502/raw/install.sh"

  # Provision LEMP
  config.vm.provision "shell", path: "lemp.sh"

  # Provision Vim

  # Provision Composer

  # Provision Laravel

end
