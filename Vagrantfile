# -*- mode: ruby -*-
# vi: set ft=ruby :

# Some variables
server_ip = "192.168.33.10"

Vagrant.configure("2") do |config|

  config.vm.hostname              = "devbox"
  config.vm.box                   = "wheezy"
  config.vm.box_url               = "http://dl.dropbox.com/u/937870/VMs/wheezy64.box"

  # Create a static IP
  config.vm.network :private_network, ip: server_ip

  # Use NFS for the shared folder
  config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime']

  # Optionally customize amount of RAM
  # allocated to the VM. Default is 384MB
  config.vm.provider :virtualbox do |vb|

    vb.customize ["modifyvm", :id, "--memory", "384"]

  end

  ####
  # Base Items
  ##########

  # Provision Packages
  config.vm.provision "shell", path: "./vpb", :args => "provision", keep_color: true

end
