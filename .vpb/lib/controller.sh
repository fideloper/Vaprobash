#!/usr/bin/env bash
#
# This file defines the controllers of the application. These functions
# are resolved by the router within main.sh, and define the bulk of the
# business logic.
#

# Disable a package by removing it from .vpb/enabled
vpb.controller._disable() {
    if [ -L "${VPB_ROOT}/enabled/$1" ] ; then
        rm "${VPB_ROOT}/enabled/$1"
    fi
}

# Enable a package by linking it into the ./vpb/enabled directory
vpb.controller._enable() {
    local package=
    local pkg_vendor=
    local pkg_name=
    local pkg_path=

    if package=($(vpb.util.resolve_package "$1")) ; then

        pkg_vendor=${package[0]}
        pkg_name=${package[1]}
        pkg_path=${package[2]}

        ln -sf "/vagrant/.vpb/packages/${pkg_vendor}/${pkg_name}" "${VPB_ROOT}/enabled/"

        vpb.util.source_package "$pkg_path"

        # Once enabled, prompt the user to configure
        vpb configure "${pkg_path}"
    fi
}

# Provision a package.
vpb.controller._provision() {
    local package=
    local pkg_vendor=
    local pkg_name=
    local pkg_path=

    if package=($(vpb.util.resolve_package "$1")) ; then

        pkg_vendor=${package[0]}
        pkg_name=${package[1]}
        pkg_path=${package[2]}

        # Load config if available.
        vpb.util.source_package "$pkg_path" config

        # Provision package.
        if vpb.util.source_package "$pkg_path" ; then
            echo
            msg "Provisioning ${pkg_vendor}:${pkg_name} ... "
        
            vpb.util.exec_hook pre_provision

            # Execute package specific functions if they are defined.
            vpb.util.exec_func pre_install
            vpb.util.exec_func install
            vpb.util.exec_func post_install
            
            vpb.util.exec_hook post_provision
        fi
    fi
}

#
# Enable and provision one or more packages non interactively.
#
# Executing this function sets a global VPB_NONINTERACTIVE variable
# for the duration of execution. This flag prevents a package's
# configure() function from being called. You will NOT be prompted
# to configure your package.
#
vpb.controller._non_interactive_provision() {
    VPB_NONINTERACTIVE=true

    for package in "$@" ; do
        vpb.controller._enable "$package"
        vpb.controller._provision "$package"
    done

    unset VPB_NONINTERACTIVE
}

# View a packages README
vpb.controller.readme() {
    local package=
    local pkg_path=

    if package=($(vpb.util.resolve_package "$1")) ; then

        pkg_path=${package[2]}

        echo
        if [ -f "$pkg_path/README.md" ] ; then
            cat "$pkg_path/README.md"
        fi
        echo
    fi
}

#
# Provisioning.
#
# If executed without any arguments this function will provision all
# currently enabled packages.
#
# Provided package names as arguments this function will enabled and
# provision those packages.
#
vpb.controller.provision() {
    if vpb.util.is_vm ; then

        if [ "$#" -gt 0 ] ; then
            vpb.controller._non_interactive_provision "$@"
        else
            vpb.util.exec_hook pre_provisioner

            for package in ${VPB_ROOT}/enabled/* ; do
                if [ "$package" != "${VPB_ROOT}/enabled/*" ] ; then
                    vpb.controller._provision "$package"
                fi
            done
        
            vpb.util.exec_hook post_provisioner
        fi
    else
        die "provision should not be called from within the host system"
    fi
}

# List available packages by looping through each vedor repo
# and calling vpb.util.get_available. This takes into account
# the fact that a package has already been enabled.
vpb.controller.available() {
    local vendors=($(vpb.util.get_vendors))
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
vpb.controller.enabled() {
    local enabled=$(vpb.util.get_enabled)
    if [ "$enabled" != "" ] ; then
        col "$enabled"
    fi
}

# API end point for vpb._enable. Allows multiple packages to be enabled at once.
vpb.controller.enable() {
    if [ "$#" -gt 1 ] ; then
        for package in "$@" ; do
            vpb.controller._enable "$package"
        done
    else
        vpb.controller._enable "$@"
    fi
}

# API end point for vpb._disable. Allows multiple packages to be disabled at once.
vpb.controller.disable() {
    if [ "$#" -gt 1 ] ; then
        for package in "$@" ; do
            vpb.controller._disable "$package"
        done
    elif [ "$1" = "all" ] ; then
        for package in $(vpb.util.get_enabled) ; do
            vpb.controller._disable "$package"
        done
    else
        vpb.controller._disable "$@"
    fi
}

# Configure a package interactively, or by setting individual options
vpb.controller.configure() {
    local package=
    local pkg_vendor=
    local pkg_name=
    local pkg_path=

    if package=($(vpb.util.resolve_package $1)) ; then
        if [ $# = 1 ] ; then
            # If we are not in not interactive mode see if we can
            # call the configure function of a package.
            if [ -z "$VPB_NONINTERACTIVE" ] ; then

                pkg_vendor=${package[0]}
                pkg_name=${package[1]}
                pkg_path=${package[2]}

                if vpb.pkg.has_configure "$pkg_path" ; then
                    vpb.util.source_package "$pkg_path" config
                    if vpb.util.func_exists configure ; then
                        configure
                        unset configure
                    fi
                fi
            fi
        elif [ $# = 3 ] ; then
            # If we are in here, we are trying to set a configure option
            vpb.pkg.config "$pkg_path" "$2" "$3"
        else
            vpb.usage && exit 1
        fi
    fi
}

# Fetch a vendor repo via git
vpb.controller.fetch() {
    if [ $# = 2 ] ; then
        if ! [ -d "${VPB_ROOT}/enabled/$1" ] ; then
            git clone "$2" "${VPB_ROOT}/packages/$1"
        else
            warn "A vendor named $1 already exists"
        fi
    else
        vpb.usage && exit 1
    fi
}

# Display usage
vpb.controller.usage() {
    vpb.usage
}
