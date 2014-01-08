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

```bash
# curl
$ curl -L http://bit.ly/vaprobash > Vagrantfile

# wget
$ wget -O Vagrantfile http://bit.ly/vaprobash
```

> The `bit.ly` link will always point to the master branch version of the Vagrantfile.

![Download the Vagranfile](https://f.cloud.github.com/assets/467411/1820040/62253bd6-70ca-11e3-8b4b-d11d5b425d10.png)

**Second**, edit the `Vagrantfile` and uncomment which scripts you'd like to run. You can uncomment them by removing the `#` character before the `config.vm.provision` line.

> You can indeed have [multiple provisioning](http://docs.vagrantup.com/v2/provisioning/basic_usage.html) scripts when provisioning Vagrant.

![Edit the Vagranfile](https://f.cloud.github.com/assets/467411/1820039/62225f1a-70ca-11e3-8977-d82e1bac3931.png)

**Third** and finally, run:

```bash
$ vagrant up
```

![Provision the Vagrant Server](https://f.cloud.github.com/assets/467411/1820038/62204842-70ca-11e3-9954-36260bf692d6.png)

## Install Scripts

The following setups are installable via the separate bash scripts of this repository.


### Base Items
---

### Base Packages

This will install some base items.

* git-core and this [.gitconfig](https://gist.github.com/fideloper/3751524)
* ack-grep
* vim, tmux
* curl, wget
* build-essential, python-software-properties

### PHP

This will install PHP 5.5.

### Oh-My-Zsh

Installs the `zsh` shell and `oh-my-zsh`. It also makes it the default shell of the `vagrant` user.

### Vim

This will install [a Vim setup](https://gist.github.com/fideloper/a335872f476635b582ee), including:

* Vundle
* Bundle 'altercation/vim-colors-solarized'
* Bundle 'plasticboy/vim-markdown'
* Bundle 'othree/html5.vim'
* Bundle 'scrooloose/nerdtree'
* Bundle 'kien/ctrlp.vim'

See [the .vimrc file](https://gist.github.com/fideloper/a335872f476635b582ee) for more details and configuration.


### Web Servers
---

### Apache Base

This will install:

* Apache 2.4.*
* PHP 5.5 mod_php5
* [This vhost](https://gist.github.com/fideloper/2710970) bash script is installed to get you started with setting up a virtual host. This will make use of [xip.io](http://xip.io), creating a virtual host for [192.168.33.10.xip.io](192.168.33.10.xip.io).

By default, the web root will the `/vagrant`, which I suggest you change as needed (within `/etc/apache2/sites-available/192.168.33.10.xip.io.conf`). The Laravel installation script will change the document root.

To create a new virtual host:

```bash
# See also: `vhost -h`
$ sudo vhost -s example.com -d /path/to/example/web/root

# You can then use `a2ensite` or `a2dissite` to enable or disable this vhost.
# `vhost` will enable it for you.
$ sudo a2dissite example.com
```

### HHVM

This will install HHVM. If provisioned, composer commands will utilize HHVM instead of the installed PHP version.

### Nginx Base

This will install:

* Nginx 1.4.* (latest stable)
* PHP 5.5 via php5-fpm
* [These virtual host configuration](https://gist.github.com/fideloper/8261546) enable/disable scripts, which work just like Apache2's `a2ensite` and `a2dissite`.

This makes use of [xip.io](http://xip.io), creating a virtual host for [192.168.33.10.xip.io](192.168.33.10.xip.io).

By default, the web root will the `/vagrant`, which I suggest you change as needed (within `/etc/nginx/sites-available/vagrant`). The Laravel installation script will change the document root.

To enable or disable a site configuration (note that `vhost` above creates a new configuration. Below only shows enabling or disabling a site configuration):

```bash
# Enable a site config:
$ sudo ngxen example.com

# Disable a site config:
$ sudo ngxdis example.com

# Reload config after any change:
$ sudo service nginx reload
```

### Databases
---

### MySQL

This will install the MySQL 5 database.

* Host: `localhost` or `192.168.33.10`
* Username: `root`
* Password: `root`

In order to create a new database to use:

```bash
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

```bash
# SSH into vagrant box
$ vagrant ssh

# Create new database via user user "postgres"
# and assign it to user "root"
$ sudo -u postgres /usr/bin/createdb --echo --owner=root your_database_name
```

### SQLite

This will install the SQLite server.

SQLite runs either in-memory (good for unit testing) or file-based.


### In-Memory Stores
---

### Memcached

This will install Memcached, which can be used for things like caching and session storage.

### Redis

This will install Redis (server). There are two options:

1. Install without journaling/persistence
2. Install with journaling/persistence

You can choose between the two by uncommenting one provision script or the other in the `Vagrantfile`.


### Utility (queues)
---

### Beanstalkd

This will install the Beanstalkd work queue.

This will configure Beanstalkd to start when the server boots.

* Host: `localhost` (`0.0.0.0` default)
* Port: `11300` (default)


### Additional Languages
---

### NodeJS

This will install Node.js `0.10.*`. It will also set global NPM items to be installed in ~/npm/bin (/home/vagrant/npm/bin).


### Frameworks, etc
---

### Composer

This will install composer and make it globally accessible.

### Laravel

This will install a base Laravel (latest stable) project within `/vagrant/laravel`. It depends on Composer being installed.

This will also attempt to change the Apache or Nginx virtual host to point the document root at `/vagrant/laravel/public`.

### Yeoman

This will install Yeoman globally for you to use in your front-end projects.

### PHPUnit

This will install PHPUnit and make it globally accessible.

## The Vagrantfile

The vagrant file does two things you should take note of:

1. **Gives the virtual machine a static IP address of 192.168.33.10.** This IP address is again hard-coded (for now) into the LAMP, LEMP and Laravel installers. This static IP allows us to use xip.io for the virtual host setups while avoiding having to edit our computers' `hosts` file.
2. **Uses NFS instead of the default file syncing.** NFS is reportedly faster than the default syncing for large files. If, however, you experience issues with the files actually syncing between your host and virtual machine, you can change this to the default syncing by deleting the lines setting up NFS:

```bash
  config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime']
```


## Contribute!

Do it! Any new install or improvement on existing ones are welcome! Please see the [contributing doc](/contributing.md), which only asks that pull requests be made to the `develop` branch.
