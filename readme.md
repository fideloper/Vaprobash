# Vaprobash

**Va**grant **Pro**visioning **Bash** Scripts

## Goal

The goal of this project is to create easy to use bash scripts in order to provision a Vagrant server.

1. This targets Ubuntu LTS releases, currently 12.04.*
2. This project will give users various popular options such as LAMP, LEMP
3. This project will attempt some modularity. For example, users might choose to install a Vim setup, or not.

Some further assumptions and self-imposed restrictions. If you find yourself needing or wanting the following, then other provisioning tool would better suited ([Chef](http://www.getchef.com), [Puppet](http://puppetlabs.com), [Ansible](http://www.ansibleworks.com)).

* If other OSes need to be accounted for
* If dependency management becomes complex (for example, installing Laravel may depend on Composer. Setting a document root for a project may change depending on Nginx or Apache).

## Instructions

**First**, Copy the Vagrantfile from this repo. You may wish to use curl or wget to do this instead of cloning the repository.

```cli
# curl
curl -L http://bit.ly/vaprobash > Vagrantfile

# wget
wget -O Vagrantfile http://bit.ly/vaprobash
```

> The `bit.ly` link will always point to the master branch version of the Vagrantfile.

**Second**, edit the `Vagrantfile` and uncomment which scripts you'd like to run.

**Third** and finally, run:

```cli
$ vagrant up
```

### LAMP

This will install:

* Apache 2.4.*
* MySQL 5
* PHP 5.5
* [This vhost](https://gist.github.com/fideloper/2710970) bash script is installed to get you started with setting up a virtual host. This will likely be setup automatically to make use of xip.io, similar to the Nginx setup.

### LEMP

This will install:

* Nginx 1.1.*
* MySQL 5
* PHP 5.5 via php5-fpm

This makes use of [xip.io](http://xip.io), creating a virtual host for [192.168.33.10.xip.io](192.168.33.10.xip.io). This let's us assign a static ip to our virtual machine and alleviates the need to edit our computers hosts file to access it.

By default, the web root will the `/vagrant`, which I suggest you change as needed (within `/etc/nginx/sites-available/vagrant'). This may get automatically updated when installing Laravel in a future release.

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

### To Do

* [ ] Test variations
* [ ] Community additions? Memcached, redis, postgresql, node, ruby, python, sass, less
