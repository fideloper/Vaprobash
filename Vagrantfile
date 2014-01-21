# -*- mode: ruby -*-
# vi: set ft=ruby :

# Some variables
server_ip = "192.168.33.10"

Vagrant.configure("2") do |config|

  # Set server to Ubuntu 12.04
  config.vm.box = "precise64"

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

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

  # vpb provisioner
  config.vm.provision "shell", path: "./vpb", :args => "provision", keep_color: true

end
