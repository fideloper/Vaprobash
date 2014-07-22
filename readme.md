# Vaprobash

**Va**&#x200B;grant **Pro**&#x200B;visioning **Bash** Scripts

[View the site and extended docs.](http://fideloper.github.io/Vaprobash/index.html)

[![Build Status](https://travis-ci.org/fideloper/Vaprobash.png?branch=master)](https://travis-ci.org/fideloper/Vaprobash)

## Goal

The goal of this project is to create easy to use bash scripts in order to provision a Vagrant server.

1. This targets Ubuntu LTS releases, currently 14.04.*
2. This project will give users various popular options such as LAMP, LEMP
3. This project will attempt some modularity. For example, users might choose to install a Vim setup, or not.

Some further assumptions and self-imposed restrictions. If you find yourself needing or wanting the following, then other provisioning tool would better suited ([Chef](http://www.getchef.com), [Puppet](http://puppetlabs.com), [Ansible](http://www.ansibleworks.com)).

* If other OSes need to be used (CentOS, Redhat, Arch, etc).
* If dependency management becomes complex. For example, installing Laravel depends on Composer. Setting a document root for a project will change depending on Nginx or Apache. Currently, these dependencies are accounted for, but more advanced dependencies will likely not be.

## Dependencies

* Vagrant `1.5.0`+
    * Use `vagrant -v` to check your version
* Vitualbox or VMWare Fusion

## Instructions

**First**, Copy the Vagrantfile from this repo. You may wish to use curl or wget to do this instead of cloning the repository.

```bash
# curl
$ curl -L http://bit.ly/vaprobash > Vagrantfile

# wget
$ wget -O Vagrantfile http://bit.ly/vaprobash
```

> The `bit.ly` link will always point to the master branch version of the Vagrantfile.

**Second**, edit the `Vagrantfile` and uncomment which scripts you'd like to run. You can uncomment them by removing the `#` character before the `config.vm.provision` line.

> You can indeed have [multiple provisioning](http://docs.vagrantup.com/v2/provisioning/basic_usage.html) scripts when provisioning Vagrant.

**Third** and finally, run:

```bash
$ vagrant up
```

**Screencast**

Here's a quickstart screencast!

[<img src="https://secure-b.vimeocdn.com/ts/463/341/463341369_960.jpg" alt="Vaprobash Quickstart" style="max-width:100%"/>](http://vimeo.com/fideloper/vaprobash-quickstart)

> <strong>Windows Users:</strong>
>
> By default, NFS won't work on Windows. I suggest deleting the NFS block so Vagrant defaults back to its default file sync behavior.
>
> However, you can also try the "vagrant-winnfsd" plugin. Just run `vagrant plugin install vagrant-winnfsd` to try it out!
>
> Vagrant version 1.5 will have [more file sharing options](https://www.vagrantup.com/blog/feature-preview-vagrant-1-5-rsync.html) to explore as well!

## Docs

[View the site and extended docs.](http://fideloper.github.io/Vaprobash/index.html)

## What You Can Install

* Base Packages
	* Base Items (Git and more!)
	* PHP (php-fpm)
	* Vim
	* PHP MsSQL (ability to connect to SQL Server)
	* Screen
* Web Servers
	* Apache
	* HHVM
	* Nginx
* Databases
	* Couchbase
	* CouchDB
	* MariaDB
	* MongoDB
	* MySQL
	* PostgreSQL
	* SQLite
* In-Memory Stores
	* Memcached
	* Redis
* Search
	* ElasticSearch and ElasticHQ
* Utility
	* Beanstalkd
	* Supervisord
* Additional Languages
	* NodeJS via NVM
	* Ruby via RVM
* Frameworks / Tooling
	* Composer
	* Laravel
	* Symfony
	* PHPUnit
	* MailCatcher

## The Vagrantfile

The vagrant file does three things you should take note of:

1. **Gives the virtual machine a static IP address of 192.168.22.10.** This IP address is again hard-coded (for now) into the LAMP, LEMP and Laravel/Symfony installers. This static IP allows us to use [xip.io](http://xip.io) for the virtual host setups while avoiding having to edit our computers' `hosts` file.
2. **Uses NFS instead of the default file syncing.** NFS is reportedly faster than the default syncing for large files. If, however, you experience issues with the files actually syncing between your host and virtual machine, you can change this to the default syncing by deleting the lines setting up NFS:

  ```ruby
  config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime']
  ```
3. **Offers an option to prevent the virtual machine from losing internet connection when running on Ubuntu.** If your virtual machine can't access the internet, you can solve this problem by uncommenting the two lines below:

  ```ruby
    #vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    #vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  ```

  Don't forget to reload your Vagrantfile running `vagrant reload --no-provision`, in case your virtual machine already exists.

## Connecting to MySQL from Sequel Pro:

Change your IP address as needed. The default IP address is now `192.168.22.10`

![sequel pro vaprobash](http://fideloper.github.io/Vaprobash/img/sequel_pro.png)

## Contribute!

Do it! Any new install or improvement on existing ones are welcome! Please see the [contributing doc](/contributing.md).
