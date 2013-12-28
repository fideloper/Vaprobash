# Vaprobash

**Va**grant **Pro**visioning **Bash** Scripts

## Goal

The goal of this project is to create easy to use bash scripts in order to provision a Vagrant server.

1. This targets Ubuntu LTS releases, currently 12.04
2. This project will give users various popular options such as LAMP, LEMP
3. This project will attempt some modularity. For example, users might choose to install a Vim setup, or not.

## Instructions

Copy the Vagrantfile from this repo. You may wish to use curl or wget to do this (instead of cloning the repository).

```cli
# curl
curl -L http://path-to-repo-master-branch/Vagrantfile > ./Vagrantfile

# wget
wget http://path-to-repo-master-branch/Vagrantfile
```

Then edit the `Vagrantfile` and uncomment which scripts you'd like to run.

Finally, run:

```cli
$ vagrant up
```

### LAMP

This will install:

* Apache 2.4.*
* MySQL 5
* PHP 5.5

### LEMP

This will install:

* Nginx 1.1.*
* MySQL 5
* PHP 5.5 via php5-fpm

### Vim

This will install [a Vim setup](https://gist.github.com/fideloper/a335872f476635b582ee), including:

* Vundle
* Bundle 'altercation/vim-colors-solarized'
* Bundle 'plasticboy/vim-markdown'
* Bundle 'othree/html5.vim'
* Bundle 'scrooloose/nerdtree'
* Bundle 'kien/ctrlp.vim'

### Composer

This will install composer and make it globally accessible.

### Laravel

This will install a base Laravel (latest stable) project. It depends on Composer being installed.



