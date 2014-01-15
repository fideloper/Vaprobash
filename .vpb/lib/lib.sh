#!/usr/bin/env bash

# Provision all enabled packages.
vpb.provision() {
    vpb.util.exec_hook pre_provision

    for package_path in ${VPB_ROOT}/enabled/* ; do
        package=${package_path##*/}
        msg "provisioning ${package} ... "
        # If any config exists, source it.
        if [ -f "$package_path/config.sh" ] ; then
            source "$package_path/config.sh"
        fi

        # Source the actual package.
        if [ -f "$package_path/package.sh" ] ; then
            source "$package_path/package.sh"

            # If package specific functions exist, execute them
            if vpb.util.func_exists pre_install ; then
                pre_install
                unset pre_install
            fi

            if vpb.util.func_exists install ; then
                install
                unset install
            fi

            if vpb.util.func_exists post_install ; then
                post_install
                unset post_install
            fi
        fi
    done

    vpb.util.exec_hook post_provision
}

# List available packages
vpb.available() {
    vendors=($(vpb.util.get_vendors))
    for vendor in ${vendors[@]} ; do
        if [[ ${#vendors[@]} > 1 ]] ; then
            # display the default venodr in red (just for fun).
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

# Enable a package
vpb.enable() {
    package="$1"
    if [[ "$package" = *:* ]] ; then
        vendor=${package%%:*}
        package=$vendor/${package##*:}
    else
        package="${VPB_DEFAULT_VENDOR:=fideloper}/$package"
    fi

    if [ -d ${VPB_ROOT}/packages/"${package}" ] ; then
        ln -sf /vagrant/.vpb/packages/"${package}" ${VPB_ROOT}/enabled/

        # If this package has a configure method, execute it.
        vpb configure "${package}"

        msg "${package} enabled"
    else
        warn "$1 not found"
    fi
}

# Disable a package
vpb.disable() {
    if [ -L ${VPB_ROOT}/enabled/"$1" ] ; then
        rm ${VPB_ROOT}/enabled/"$1"
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
