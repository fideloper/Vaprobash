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
      List available packages

  vpb enabled
      List enabled packages

  vpb enable [vendor]:<package> [...]
      Enable a list of packages

  vpb disable <package> [...]
      Disable a list of packages

  vpb configure [vendor]:<package> [token] [value]
      Configure a package

  vpb readme [vendor]:<package>
      View a package README

  vpb fetch <vendor> <url>
      Fetch a vendor repo - accepts any valid git url

  vpb provision <package> [...]
      Enable and provision one or more packages non-interactively

  vpb runner
      Provision all enabled packages
```

### An Overview

vpb is really a very simple tool. At it's heart, the cli is designed
to manage symlinks within the ${VPB_ROOT}/enabled directory. Available
packages are placed within ${VPB_ROOT}/packages, each within there own
vendor directory. When a package is enabled, a symlink is created from
${VPB_ROOT}/packages/vendor/package to ${VPB_ROOT}/enabled.

When Vagrant provisions a VM the directory containing your Vagrantfile is
mounted as /vargrant on the VM, vagrant then executes `.vpb runner` from
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
installation of your package. It should be broken down into the following
functions:

```bash
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
executed __top to bottom__, breaking it down into the functions above will
provide greater flexibility in the future and will hopefully allow us to
abstract some functionality away into common libraries.

Lets take a look at converting an existing script to the newer style. The current
php package.sh looks like this:

```bash
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

```bash
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

At this early stage, it doesn't really look like there are too many benefits
to breaking the package into parts. Don't be fooled however, even without much
of a framework developed yet, just breaking our package up has made it much more
flexible.

If we wanted to install `php5-xcache` for instance, we can build on the above
package by extending it:

```bash
vpb.pkg.extends example/php

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
style scripts.

The above is actually a pretty trivial example because things like adding new
extensions to php will ideally be handled (in the future) by configuration, but
that is beside the point, it's a simple example.

#### Configuring a package

Just prior to sourcing a packages package.sh file vpb checks for the existence
of a config.sh file and if it exists it sources it. This file should contain any
variable declarations required by the package.

For instance, the `mysql` package may contain a config.sh file that looks like
this:

```bash
mysql_root_password="root"
```

Within the `mysql/package.sh` then is the following line making use of this
variable:

```bash
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password:"
```

To make things easier. vpb provides a *very* simple interface to editing
variables within config.sh files, *configure*. From the command line:

```bash
$ ./vpb configure mysql mysql_root_password root
```

The above command will check for the existence of the config.sh file within the
mysql package and if it doesn't exist, create it. It then either edits, or adds
the variable.

#### Interactive package configuration

In the initial example where we described the basic layout of a package I made
mention of a configure function but didn't really go into any details of what
this is used for:

```bash
# Code to prompt user to configure the package
configure() {}
```

Given the `mysql` example above we might define our configure function like the
following:

```bash
configure() {
    echo "Please provide a mysql root password: "
    read pw
    vpb.pkg.config mysql mysql_root_password "$pw"
}
```

A package's `configure` function is called when a package is enabled from the
command line or when you specifically call `./vpb configure package`

Packages enabled and provisioned via the *provision* option will not prompt
a user for any input in regards to configuration. This option is designed
specifically to be used to script your provisioning.

#### The framework

What is this `vpb.pkg.config` used in the above example? This is
part of the framework provided by vpb. At this stage, there is very little
available, but the `${VPB_ROOT}/lib/util.sh` script might be of use to those
interested. All code within vpb is already sourced and available to use within
your packages.

Oh, but really... what does this `vpb.pkg.config` function do? It writes
a variable to a packages config.sh file.

```bash
vpb.pkg.config <package> <option> <value>
```

#### What about those of us not using *nix ?

Your fools. No, sorry..... See the below section on hooks.

#### Hooks

There exists the concept of __hooks__ within vpb. Presently there are a
a few hook points defined:

* pre_provisioner
  - Executed just prior to the provision action runner executing provisioning.
    This hook is triggered when vagrant runs `vpb provision`

* post_provisioner
  - Executed just after the provision action has executed provisioning.

* pre_provision
  - Executed just prior to the provisioning of a package. This hook has access
    to all of a packages functions, variables and configuration.

* post_provision
  - Executed just after the provisioning of a package. This hook has access
    to all of a packages functions, variables and configuration.

Hooks are an extremely useful tool as they allow us to inject arbitrary code
into the flow of vpb. In some way though, packages are just another hook. Package
script are actually just sourced and executed between pre_provision and post_provision.

We could in fact implement the same example as above where we overloaded the php
package's `install` method using the pre_provisioner hook.

```bash
if [ "$pkg_name" = "php" ] ; then

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

fi
```

So, just to make things a little clearer, if we were to have the `base` and
`php` packages enabled. Our execution path would look something like this
(picked up from where provisioning starts):

```
|--- provision
  |--- pre_proviosioner

    |--- source::base/package.sh
    |--- source::base/config.sh
    |--- pre_provision
      |--- base::pre_install()
      |--- base::install()
      |--- base::post_install()
    |--- post_provision

    |--- source::php/package.sh
    |--- source::php/config.sh
    |--- pre_provision
      |--- php::pre_install()
      |--- php::install()
      |--- php::post_install()
    |--- post_provision

  |--- post_proviosioner
```
 
Another example use case for hooks is where you need to script some functionality.

### Scripting provisioning

For instance, Windows users wont have access to Bash, vpb's cli will be of now
use, and they'll have a hard time creating the links that are required to enable
packages within vpb. Using a hook we can get around this issue by scripting our
provisioning.

In fact, at this point in time we need to script all provisioning as there is
currently no dependency management built into the system. We need to script our
provisioning to ensure that packages are provisioned in the order that makes
sense.

The pre_provisioner.sh hook script will disable (not un-install) any previously
enabled packages, post_provisioner.sh will then enable the packages that you
want. It may seem like these hooks are being used in the wrong order, but if we
where to enable packages within the pre_provisioner hook they would actually be
executed again by the provisioning loop. __Be careful not to get stuck in any
loops__.

```bash
# pre_provisioner.sh

vpb disable all
```

```bash
# post_provisioner.sh

vpb provision base
vpb provision php
```

There is a (hopefully) working example of the scripting of provisioning already
setup within the hooks directory, just remove the -dist part from both the
pre_provisioner.sh and post_provisioner.sh hook scripts.
 
### Variables

#### Glabals

While as much care has been taken as possible to only expose what is useful,
within the runtime environment there are a few variables made globally
available. They are:

The path to the .vpb directory
```
VPB_ROOT
```

#### Package level variables

As well as the globals mentioned above, within a package you also have access
to these useful variables plus any other variables defined within the packages
configuration.

The path to the package directory
```
pkg_path
```

The current vendor name
```
pkg_vendor
```

The package name
```
pkg_name
```
