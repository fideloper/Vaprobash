#!/usr/bin/env bash
#
# This file defines the controllers of the application. These functions
# are resolved by the router within main.sh, and define the bulk of the
# business logic.
#

# Provision all enabled packages.
vpb.provision() {
    vpb.util.exec_hook pre_provision

    for package_path in ${VPB_ROOT}/enabled/* ; do
        echo
        msg "provisioning ${package_path##*/} ... "

        # If any config exists, source it.
        if [ -f "$package_path/config.sh" ] ; then
            source "$package_path/config.sh"
        fi

        # Source the actual package.
        if [ -f "$package_path/package.sh" ] ; then
            source "$package_path/package.sh"

            # Execute package specific functions if they are defined.
            vpb.util.exec_func pre_install
            vpb.util.exec_func install
            vpb.util.exec_func post_install
        fi
    done

    vpb.util.exec_hook post_provision
}

# List available packages by looping through each vedor repo
# and calling vpb.util.get_available. This takes into account
# the fact that a package has already been enabled.
vpb.available() {
    vendors=($(vpb.util.get_vendors))
    for vendor in ${vendors[@]} ; do
        if [[ ${#vendors[@]} > 1 ]] ; then
            # Display the default venodr in red (just for fun).
            if vpb.util.is_default_vendor "$vendor" ; then
                error "${vendor}*"
            else
                msg "${vendor}"
            fi
        fi
        col "$(vpb.util.get_available "$vendor")"
    done
}

# List enabled packages
vpb.enabled() {
    col "$(vpb.util.get_enabled)"
}

# Enable a package by linking it into the ./vpb/enabled directory
vpb._enable() {
    package="$(vpb.util.resolve_package $1)"
    if [ -d ${VPB_ROOT}/packages/"${package}" ] ; then
        ln -sf /vagrant/.vpb/packages/"${package}" ${VPB_ROOT}/enabled/

        # Once enabled, prompt the user to configure
        vpb configure "${1}"
    else
        warn "${package} not found"
    fi
}

# API end point for vpb._enable. Allows multiple packages to be enabled at once.
vpb.enable() {
    if [ $# > 1 ] ; then
        for pkg in "$@" ; do
            vpb._enable "$pkg"
        done
    else
        vpb._enable "$@"
    fi
}

# Disable a package by removing it from .vpb/enabled
vpb._disable() {
    if [ -L ${VPB_ROOT}/enabled/"$1" ] ; then
        rm ${VPB_ROOT}/enabled/"$1"
    fi
}

# API end point for vpb._disable. Allows multiple packages to be disabled at once.
vpb.disable() {
    if [ $# > 1 ] ; then
        for pkg in "$@" ; do
            vpb._disable "$pkg"
        done
    else
        vpb._disable "$@"
    fi
}

# Configure a package interactively, or by setting individual options
vpb.configure() {
    if [ $# = 1 ] ; then
        # If we are not in not interactive mode see if we can
        # call the configure function of a package.
        if [ -z "$VPB_NONINTERACTIVE" ] ; then
            package="$(vpb.util.resolve_package $1)"
            # Check to see if a configure function exists in the package file.
            # We can't just source the file and see if it is defined because this
            # will potentially trigger provisioning in the older legacy scripts
            # that have all there code in the global namespace.
            if grep -q "^configure()" "${VPB_ROOT}/packages/${package}/package.sh" ; then
                source "${VPB_ROOT}/packages/${package}/package.sh"
                configure
            fi
        fi
    elif [ $# = 3 ] ; then
        # If we are in here, we are trying to set a configure option
        package="$1"; option="$2"; value="$3"
        vpb.util.config_option $package $option $value
    else
        vpb.usage && exit 1
    fi
}

# Fetch a vendor repo via git
vpb.fetch() {
    echo $#
    if [ $# = 2 ] ; then
        if ! [ -d ${VPB_ROOT}/enabled/"$1" ] ; then
            git clone "$2" ${VPB_ROOT}/packages/"$1"
        else
            warn "$1 already exists"
        fi
    else
        vpb.usage && exit 1
    fi
}
