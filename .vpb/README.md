# VPB

## DESCRIPTION

vpb is both a runtime environment and a configuration framework for managing
VaproBash provisioning scripts. These scripts (referred to as packages within
vpb) are designed to provision software on a Vagrant managed virtual machine.

vpb provides a command line interface used to easily enable, disable, configure
and manage packages within VaproBash. As well as providing this command line
interface to end users, vpb hopes to provide a simple framework to make creating
and configuring more flexible packages easier.

## DOCUMENTATION

This is it. Live with it.

### Usage

What can this thing do?

```
Usage:
  vpb available
      list available packages

  vpb enabled
      list enabled packages

  vpb enable [vendor]:<package>
      enable a package

  vpb disable <package>
      disable a package

  vpb configure [vendor]:<package> [option] [value]
      interactively configure a package or edit an option on apackage

  vpb fetch <vendor> <url>
      fetch a vendor repo - accepts any valid git url

  vpb provision
      execute the provisioner
```

### An Overview

vpb is really a very simple tool. At it's heart, the cli is designed
to manage symlinks within the ${VPB_ROOT}/enabled directory. Available
packages are placed within ${VPB_ROOT}/packages, each within there own
vendor directory. When a package is enabled, a symlink is created from
${VPB_ROOT}/packages/vendor/package to ${VPB_ROOT}/enabled.

When Vagrant provisions a VM the directory containing your Vagrantfile is
mounted as /vargrant on the VM, vagrant then executes `.vpb provision` from
within this directory.

From here, execution is handled by vpb which simply loops through all the
symlinks within ${VPB_ROOT}/enabled, sources each packages package.sh file and
executes the provisioning of the package.

Legacy scripts are supported as is, as they execute when they are sourced. To
allow greater flexibility in the future however, newer packages being executed
via vpb should break the different parts of there execution into the designated
functions.

#### What is a package?

At minimum, a package requires two things. A directory to be housed in and
a package.sh file. The directory the package is housed in is important as
it represents the name of the package. Only one package per name can be
provisioned. For instance, you can only enable a single `php` package. You could
however potentially enable both a `php54` and `php55` package side by side.

The package.sh script is what does the heavy lifting in relation to the
installation of your package. It should br broken down into the following
functions:

```
# Any pre installation code (loading of new repos etc etc) should go in here
pre_install() {}

# The code that actually does the installation
install() {}

# Any clean up after installation or package configuration
post_install() {}

# Code to prompt user to configure the package
configure() {}
```

#### Converting a legacy package to VPB.

While the package.sh file could potentially be a simple script that just
executed __top to bottom__ breaking it down into the functions above will provide
greater flexibility in the future and will hopefully allow us to abstract some
functionality away into common libraries.

Lets take a look at converting an existing script to the newer style. The current
php package.sh looks like this:

```
# Add repo for latest PHP
sudo add-apt-repository -y ppa:ondrej/php5

# Update Again
sudo apt-get update

# Install PHP
sudo apt-get install -y php5-cli php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-mcrypt php5-xdebug php5-memcached

# xdebug Config
cat > /etc/php5/mods-available/xdebug.ini << EOF
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF
```

A very simple conversion looks like:

```
pre_install() {
    # Add repo for latest PHP
    sudo add-apt-repository -y ppa:ondrej/php5

    # Update Again
    sudo apt-get update
}

install() {
    # Install PHP
    sudo apt-get install -y \
        php5-cli            \
        php5-mysql          \
        php5-pgsql          \
        php5-sqlite         \
        php5-curl           \
        php5-gd             \
        php5-mcrypt         \
        php5-xdebug         \
        php5-memcached
}

post_install() {
    # xdebug Config
    cat > /etc/php5/mods-available/xdebug.ini << EOF
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF
}
```

#### What has this bought us?

At this early stage, it doesn't really look like there are too many benifits
to breaking the package into parts. Don't be fooled however, even without much
a framework developed yet, just breaking our package up has made it much more
flexible.

If we wanted to install `php5-xcache` for instance, we can build on the above
package by extending it:

```
source ${VPB_ROOT}/packages/example/php

install() {
    # Install PHP
    sudo apt-get install -y \
        php5-cli            \
        php5-mysql          \
        php5-pgsql          \
        php5-sqlite         \
        php5-curl           \
        php5-gd             \
        php5-mcrypt         \
        php5-xdebug         \
        php5-memcached      \
        php5-xcache
}
```

Note that we only need to define the function we are overwriting. Already, this
is much more convenient than what was provided in the old __top to bottom__
style script.

The above is actually a pretty trivial example because things like adding new
extensions to php will ideally be handled (in the future) by configuration, but
that is beside the point, it's a simple example.

#### Configuring a package

Just prior to sourcing a packages package.sh file vpb checks for the existence
of a config.sh file and if it exists it sources it. This file should contain any
variable declarations required by the package.

For instance, the `mysql` package may contain a config.sh file that looks like
this:

```
mysql_root_password="root"
```

Within the `mysql/package.sh` then is the following line making use of this
variable:

```
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password:"
```

To make things easier. vpb provides a *very* simple interface to editing
variables within config.sh files, *configure*. From the command line:

```
$ ./vpb configure mysql mysql_root_password root
```

The above command will check for the existence of the config.sh file within the
mysql package and if it doesn't exist, create it. It then either edits, or adds
the variable.

#### Interactive package configuration

In the initial example where we described the basic layout of a package I made
mention of a configure function but didn't really go into any details of what
this is used for:

```
# Code to prompt user to configure the package
configure() {}
```

Given the `mysql` example above we might define our configure function like the
following:

```
configure() {
    echo "Please provide a mysql root password: "
    read pw
    vpb.util.config_option mysql mysql_root_password "$pw"
}
```

A package's `configure` function is called when a package is enabled from the
command line or when you specifically call `./vpb configure package`

#### The framework

What is this `vpb.util.config_option` used in the above example? This is
part of the framework provided by vpb. At this stage, there is very little
available, but the `${VPB_ROOT}/lib/util.sh` script might be of use to those
interested. All code within vpb is already sourced and available to use within
your packages.

Oh, but really... what does this `vpb.util.config_option` function do? It writes
a variable to a packages config.sh file.

```
vpb.util.config_option <package> <option> <value>
```

#### What about those of us not using *nix ?

Your fools. No sorry.... really. See the below section on hooks.

#### Hooks

There idea of __hooks__ exists within vpb. Presently there are two hook points
defined. A pre_provision hooks point executed just prior to the provisioning of
all packages and a post_provision hooks point executed shortly after.

An example usage case within the pre_provision hook point is to script the
enabling and configuration of packages within the VM just prior to provisioning.

If you are using Windows as your host, this may indeed be the only way you
can use vpb. There is already an example pre_provision hook setup to imitate
the basic functionality already available within VaproBash within the hooks
directory. If you want to use it, remove the -dist part from the file name.
 
### Globally available variables

Within the runtime environment there are a few variables made globally available. They are:

The path to the .vpb directory
```
VPB_ROOT
```
