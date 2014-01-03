# Vaprobash

**Va**grant **Pro**visioning **Bash** Scripts

## Goal

The goal of this project is to create easy to use bash scripts in order to provision a Vagrant server.

1. This targets Ubuntu LTS releases, currently 12.04.*
2. This project will give users various popular options such as LAMP, LEMP
3. This project will attempt some modularity. For example, users might choose to install a Vim setup, or not.

Some further assumptions and self-imposed restrictions. If you find yourself needing or wanting the following, then other provisioning tool would better suited ([Chef](http://www.getchef.com), [Puppet](http://puppetlabs.com), [Ansible](http://www.ansibleworks.com)).

* If other OSes need to be used (CentOS, Redhat, Arch, etc).
* If dependency management becomes complex. For example, installing Laravel depends on Composer. Setting a document root for a project will change depending on Nginx or Apache. Currently, these dependencies are accounted for, but more advanced dependencies will likely not be.

## Instructions

**First**, Copy the Vagrantfile from this repo. You may wish to use curl or wget to do this instead of cloning the repository.

```cli
# curl
$ curl -L http://bit.ly/vaprobash > Vagrantfile

# wget
$ wget -O Vagrantfile http://bit.ly/vaprobash
```

> The `bit.ly` link will always point to the master branch version of the Vagrantfile.

![Download the Vagranfile](https://f.cloud.github.com/assets/467411/1820040/62253bd6-70ca-11e3-8b4b-d11d5b425d10.png)

**Second**, edit the `Vagrantfile` and uncomment which scripts you'd like to run. You can uncomment them by removing the `#` character before the `config.vm.provision` line.

> You can indeed have [multiple provisioning](http://docs.vagrantup.com/v2/provisioning/basic_usage.html) scripts when provisioning Vagrant.

```cli
  # Provision Base Packages
  config.vm.provision "shell", path: "https://raw.github.com/#{github_username}/#{github_repo}/#{github_branch}/scripts/base.sh"

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
```

![Edit the Vagranfile](https://f.cloud.github.com/assets/467411/1820039/62225f1a-70ca-11e3-8977-d82e1bac3931.png)

**Third** and finally, run:

```cli
$ vagrant up
```

![Provision the Vagrant Server](https://f.cloud.github.com/assets/467411/1820038/62204842-70ca-11e3-9954-36260bf692d6.png)

## Install Scripts

The following setups are installable via the separate bash scripts of this repository.

### Apache Base

This will install:

* Apache 2.4.*
* PHP 5.5 mod_php5
* [This vhost](https://gist.github.com/fideloper/2710970) bash script is installed to get you started with setting up a virtual host. This will make use of [xip.io](http://xip.io), creating a virtual host for [192.168.33.10.xip.io](192.168.33.10.xip.io).

By default, the web root will the `/vagrant`, which I suggest you change as needed (within `/etc/apache2/sites-available/192.168.33.10.xip.io.conf`). The Laravel installation script will change the document root.

### Nginx Base

This will install:

* Nginx 1.4.* (latest stable)
* PHP 5.5 via php5-fpm

This makes use of [xip.io](http://xip.io), creating a virtual host for [192.168.33.10.xip.io](192.168.33.10.xip.io).

By default, the web root will the `/vagrant`, which I suggest you change as needed (within `/etc/nginx/sites-available/vagrant`). The Laravel installation script will change the document root.

### MySQL

This will install the MySQL 5 database.

* Host: `localhost` or `192.168.33.10`
* Username: `root`
* Password: `root`

In order to create a new database to use:

```cli
# SSH into Vagrant box
$ vagrant ssh

# Create Database
# This will ask you to enter your password
$ mysql -u root -p -e "CREATE DATABASE your_database_name"
```

### PostgreSQL

This will install the PostgreSQL 9.3 database.

* Host: `localhost`
* Username: `root`
* Password: `root`

In order to create a new database to use:

```cli
# SSH into vagrant box
$ vagrant ssh

# Create new database via user user "postgres"
# and assign it to user "root"
$ sudo -u postgres /usr/bin/createdb --echo --owner=root your_database_name
```

### Vim

This will install [a Vim setup](https://gist.github.com/fideloper/a335872f476635b582ee), including:

* Vundle
* Bundle 'altercation/vim-colors-solarized'
* Bundle 'plasticboy/vim-markdown'
* Bundle 'othree/html5.vim'
* Bundle 'scrooloose/nerdtree'
* Bundle 'kien/ctrlp.vim'

See [the .vimrc file](https://gist.github.com/fideloper/a335872f476635b582ee) for more details and configuration.

### Composer

This will install composer and make it globally accessible.

### Laravel

This will install a base Laravel (latest stable) project within `/vagrant/laravel`. It depends on Composer being installed.

This will also attempt to change the Apache or Nginx virtual host to point the document root at `/vagrant/laravel/public`.

## The Vagrantfile

The vagrant file does two things you should take note of:

1. **Gives the virtual machine a static IP address of 192.168.33.10.** This IP address is again hard-coded (for now) into the LAMP, LEMP and Laravel installers. This static IP allows us to use xip.io for the virtual host setups while avoiding having to edit our computers' `hosts` file.
2. **Uses NFS instead of the default file syncing.** NFS is reportedly faster than the default syncing for large files. If, however, you experience issues with the files actually syncing between your host and virtual machine, you can change this to the default syncing by deleting the lines setting up NFS:

```cli
  config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime']
```

### To Do

* [ ] Test variations further
* [ ] Make gitconfig (but not git) a separate install?
* [ ] Community additions? Memcached, redis, postgresql, node, ruby, python, sass, less, fish/zsh
