#!/usr/bin/env bash
#
# Just a place to keep the usage outside of the logic of the application
#

vpb.usage() {
cat <<-EOF

Usage:

$0 <command> [args] 

    commands:

      available
        List available packages

      enabled
        List enabled packages

      enable [vendor]:<package> [...]
        Enable a list of packages

      disable <package> [...]
        Disable a list of packages

      configure [vendor]:<package> [token] [value]
        Configure a package

      readme [vendor]:<package>
        View a package README

      fetch <vendor> <url>
        Fetch a vendor repo - accepts any valid git url

      provision [<package>]...
        Called without arguments, provision will provision all enabled packages.
        Otherwise, it will enable and provision one or more packages non-interactively

EOF
}
