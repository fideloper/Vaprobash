#!/usr/bin/env bash
#
# Just a place to keep the usage outside of the logic of the application
#

vpb.usage() {
    echo "Usage:"
    echo "  ${0} available"
    echo "      list available packages"
    echo
    echo "  ${0} enabled"
    echo "      list enabled packages"
    echo
    echo "  ${0} enable [vendor]:<package> [...]"
    echo "      enable a list of packages"
    echo
    echo "  ${0} disable <package> [...]"
    echo "      disable a list of packages"
    echo
    echo "  ${0} configure [vendor]:<package> [token] [value]"
    echo "      configure a package"
    echo
    echo "  ${0} fetch <vendor> <url>"
    echo "      fetch a vendor repo - accepts any valid git url"
    echo
    echo "  ${0} provision"
    echo "      execute the provisioner"
    echo
}
