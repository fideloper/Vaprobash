vpb.usage() {
    echo "Usage:"
    echo "  ${0} available"
    echo "      list available packages"
    echo
    echo "  ${0} enabled"
    echo "      list enabled packages"
    echo
    echo "  ${0} enable [vendor]:<package>"
    echo "      enable a package"
    echo
    echo "  ${0} disable <package>"
    echo "      disable a package"
    echo
    echo "  ${0} configure [vendor]:<package>"
    echo "      configure a package"
    echo
    echo "  ${0} fetch <vendor> <url>"
    echo "      fetch a vendor repo - accepts any valid git url"
    echo
    echo "  ${0} provision"
    echo "      execute the provisioner"
    echo
}
