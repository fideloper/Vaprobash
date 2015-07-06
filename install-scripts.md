---
layout: default
title: Install Scripts
---

Vaprobash has many install scripts! Here's an overview of each of them.

## Base Items

### <a href="install-scripts.html#base" name="base" id="base">#</a> Base

This installs some basics items.

- Git and this [.gitconfig](https://gist.github.com/fideloper/3751524)
- ack-grep
- vim, tmux
- curl, wget
- build-essential, python-software-properties
- SSL certificate (self-signed) for [#](https://*.xip.io) addresses

### <a href="install-scripts.html#base" name="php" id="php">#</a> PHP

This will install PHP 5.5 and its common modules. This also install xdebug and sets the following:

```
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
```

### <a href="install-scripts.html#screen" name="screen" id="screen">#</a> Screen

This will install the Screen terminal multiplexer on the Vagrant VM. A few sensible defaults will be added to the `.screenrc` file.

### <a href="install-scripts.html#base" name="vim" id="vim">#</a> Vim

This will install a Vim set, including:

- Vundle
- Bundle 'altercation/vim-colors-solarized'
- Bundle 'plasticboy/vim-markdown'
- Bundle 'othree/html5.vim'
- Bundle 'scrooloose/nerdtree'
- Bundle 'kien/ctrlp.vim'
- Bundle 'bling/vim-airline'
- Bundle 'airblade/vim-gitgutter'
- Bundle 'tpope/vim-fugitive'

See the [.vimrc](https://gist.github.com/fideloper/a335872f476635b582ee) file for more details and configuration.

## Web Servers

### <a href="install-scripts.html#apache" name="apache" id="apache">#</a> Apache

This will install Apache 2.4 and mod_php5. Additionally, this script will use [this vhost bash script](https://gist.github.com/fideloper/2710970) to create a virtualhost for 192.168.33.10.xip.io (or whichever IP address you configure).

<p class="alert alert-warning">In future releases, Apache may be changed to work with php5-fpm rather than mod_php5. This will make switching between Nginx and Apache simpler.</p>

By default, the web root will the `/vagrant`, which I suggest you change as needed (within `/etc/apache2/sites-available/192.168.33.10.xip.io.conf`). The Laravel and Symfony installation script will change the document root.

To create a new virtual host:

```bash
# See also: `vhost -h`
$ sudo vhost -s example.com -d /path/to/example/web/root

# You can then use `a2ensite` or `a2dissite` to enable or disable this vhost.
# `vhost` will enable it for you.
$ sudo a2dissite example.com
```

### <a href="install-scripts.html#base" name="hhvm" id="hhvm">#</a> HHVM

This installs HHVM.

<p class="alert alert-warning">This will be modified heavily in the near future, likely to install hhvm-fastcgi rather than simply hhvm. There are also some configuration concerns which needs to be dealt with.</p>

### <a href="install-scripts.html#nginx" name="nginx" id="nginx">#</a> Nginx Base

This will install:

- Nginx 1.4.* (latest stable)
- PHP 5.5 via php5-fpm
- [These virtualhost configuration](https://gist.github.com/fideloper/8261546) enable/disable scripts, which works similarly to Apache's `a2ensite` and `a2dissite`.

Similar to the Apache setup, this makes use of [xip.io](http://xip.io), creating a virtual host for the address 192.168.33.10.xip.io (or whatever IP address is configured).

By default, the web root will be in the `/vagrant` directory. You can change this as needed within the `/etc/nginx/sites-available/vagrant` file. Note that the Laravel installation script will change the document root.

To enable or disable an existing site configuration:

```bash
# Enable a site config:
$ sudo ngxen example.com

# Disable a site config:
$ sudo ngxdis example.com

# Reload config after any change:
$ sudo service nginx reload
```

## Databases

### <a href="install-scripts.html#couchbase" name="couchbase" id="couchbase">#</a> Couchbase

This will install Couchbase Server Community Edition 2.2.0 and its PHP Client Library.

To configure:

- Run the setup wizard on the web interface at http://192.168.33.10:8091
- Use the CLI in /opt/couchbase/bin/couchbase-cli

More info:

- [Couchbase](http://www.couchbase.com/)
- [PHP Client Library](http://www.couchbase.com/communities/php/getting-started)

### <a href="install-scripts.html#couchdb" name="couchdb" id="couchdb">#</a> CouchDB

This will install the CouchDB database.

To create a new database:

```bash
# Execute this command inside the Vagrant box
$ curl -X PUT localhost:5984/name_of_new_database
```

You may access the "Futon" web interface for administering CouchDB at: `http://192.168.33.10:5984/_utils/`

### <a href="install-scripts.html#mariadb" name="mariadb" id="mariadb">#</a> MariaDB

This is a drop-in replacement for MySQL. See MySQL docs below for usage information.

### <a href="install-scripts.html#mysql" name="mysql" id="mysql">#</a> MySQL

This will install the MySQL 5 database.

- Host: `localhost` or `192.168.33.10`
- Username: `root`
- Password: `root`

In order to create a new database:

```bash
# SSH into Vagrant box
$ vagrant ssh

# Create Database
# This will ask you to enter your password
$ mysql -u root -p -e "CREATE DATABASE your_database_name"
```

### <a href="install-scripts.html#mongodb" name="mongodb" id="mongodb">#</a> MongoDB

This installs MongoDB. See some [basic usage here](http://docs.mongodb.org/manual/tutorial/getting-started/).

### <a href="install-scripts.html#pgsql" name="pgsql" id="pgsql">#</a> PostgreSQL

This will install the PostgreSQL 9.3 database.

- Host: `localhost` or `192.168.33.10`
- Username: `root`
- Password: `root`

In order to creat a new database:

```bash
# SSH into vagrant box
$ vagrant ssh

# Create new database via user user "postgres"
# and assign it to user "root"
$ sudo -u postgres /usr/bin/createdb --echo --owner=root your_database_name
```

### <a href="install-scripts.html#sqlite" name="sqlite" id="sqlite">#</a> SQLite

This will install the SQLite server. SQLite runs either in-memory (good for unit testing) or file-based.

## In-Memory Stores

### <a href="install-scripts.html#memcached" name="memcached" id="memcached">#</a> Memcached

This will install Memcached, which can be used for things like caching and session storage.

- Host: `localhost`
- Port `11211` (default)

### <a href="install-scripts.html#redis" name="redis" id="redis">#</a> Redis

This will install Redis (server). There are two options:

- Install without journaling/persistence
- Install with journaling/persistence

You can choose between the two by uncommenting one provision script or the other in the `Vagrantfile`.

## Search

### <a href="install-scripts.html#elasticsearch" name="elasticsearch" id="elasticsearch">#</a> ElasticSearch

This install ElasticSearch latest version. See a [getting started](http://joelabrahamsson.com/elasticsearch-101/) article.

## Utility (queues)

### <a href="install-scripts.html#beanstalkd" name="beanstalkd" id="beanstalkd">#</a> Beanstalkd

This will install the Beanstalkd work queue and configure it to start when the server boots.

- Host: `localhost` (`0.0.0.0` by default)
- Port: `11300` (default)

### <a href="install-scripts.html#heroku" name="heroku" id="heroku">#</a> Heroku

Install the [Heroku Toolbelt](https://toolbelt.heroku.com/). This is not a Vaprobash script but Heroku's. The install script is just added for convenience.

### <a href="install-scripts.html#supervisord" name="supervisord" id="supervisord">#</a> Supervisord

This install Supervisord, a process watcher which can restart processes if they fail and boot them on system start. More information [here](http://supervisord.org/) and a getting started guide with PHP/Laravel [here](http://fideloper.com/ubuntu-beanstalkd-and-laravel4).

### <a href="install-scripts.html#zeromq" name="zeromq" id="zeromq">#</a> ØMQ

This will install ØMQ (ZeroMQ), a messaging library, and configure itself for use with PHP. More information is [available online](http://zeromq.org/intro:read-the-manual).

## Additional Languages

### <a href="install-scripts.html#nodejs" name="nodejs" id="nodejs">#</a> NodeJS

By default the latest stable NodeJS will be installed using [Node Version Manager](https://github.com/creationix/nvm). Type `$ nvm help` in the console/terminal or read [this](https://github.com/creationix/nvm/blob/master/README.markdown) for more info on NVM.

You can configure the NodeJS version and the Global Node Packages within the Vagrantfile.

```ruby
nodejs_version = "latest" # <-- latest stable NodeJS version will be installed
```

It will also set global NPM items to be installed in `/home/vagrant/npm/bin`.

### <a href="install-scripts.html#node_packages" name="node_packages" id="node_packages">#</a> NodeJS Packages

You can have as many packages installed or choose to not install any packages at all (just comment or delete the lines). Type `$ nvm ls-remote` to get the full list of available NodeJS versions inside your console/terminal.

```ruby
nodejs_packages = [ # List any global Node.js modules that you want to install
    #"grunt-cli",
    #"bower",
    "yo",             # "yo" is uncommented and will be installed globally (yeoman.io)
                      # ... add more packages or delete all packages if you don't want any
]
```

### <a href="install-scripts.html#ruby" name="ruby" id="ruby">#</a> Ruby

This will install Ruby via RVM. You can decide which version of ruby via the configuration variable found in the Vagrantfile. Default is `latest`.

Similar to Node, you can select which Ruby Gems to install (globally!) on your system.

```ruby
ruby_gems = [ # List any Ruby Gems that you want to install
  #"jekyll",
  #"sass",
  "compass",  # Will install Compass as its un-commented
]
```

## Frameworks and Tooling

### <a href="install-scripts.html#composer" name="composer" id="composer">#</a> Composer

This will install composer and make it globally accessible.

### <a href="install-scripts.html#laravel" name="laravel" id="laravel">#</a> Laravel

This will install a base Laravel (latest stable) project within `/vagrant/laravel`. It depends on Composer being installed.

This will also attempt to change the Apache or Nginx virtual host to point the document root at `/vagrant/laravel/public`.

### <a href="install-scripts.html#symfony" name="symfony" id="symfony">#</a> Symfony

This will install a base Symfony (latest stable) project within `/vagrant/symfony`. It depends on Composer being installed.

This will also attempt to change the Apache or Nginx virtual host to point the document root at `/vagrant/symfony/web`.

### <a href="install-scripts.html#phpunit" name="phpunit" id="phpunit">#</a> PHPUnit

This will install PHPUnit and make it globally accessible.

### <a href="install-scripts.html#mailcatcher" name="mailcatcher" id="mailcatcher">#</a> MailCatcher

This will install [MailCatcher](http://mailcatcher.me) to catch outgoing mail. Sets `php.ini` sendmail path to catchmail.

- MailCatcher frontend at 192.168.33.10.xip.io:1080
- MailCatcher SMTP at 192.168.33.10.xip.io:1025

### <a href="install-scripts.html#gitftp" name="gitftp" id="gitftp">#</a> git-ftp

This will install [git-ftp](http://git-ftp.github.io/git-ftp/) and will allow you to deploy your git repository trough FTP.

Installing git-ftp is especcially handy when your hosting provider (ie shared hosting) doesn't support git and doesn't allow SSH access. git-ftp supports the fallowing protocol's: `FTP`, `SFTP`, `FTPS` and `FTPES` (SSL).

You can find more info on how to configure and use git-ftp [here](https://github.com/git-ftp/git-ftp/blob/develop/man/git-ftp.1.md) (manual).
