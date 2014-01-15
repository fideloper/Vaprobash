#!/usr/bin/env bash

# Provision all enabled packages.
vpb.provision() {
    if [ -f ${VPB_ROOT}/pre_provision.sh ] ; then
        source ${VPB_ROOT}/pre_provision.sh
    fi

    for package_path in ${VPB_ROOT}/enabled/* ; do
        package=${package_path##*/}
        msg "Provisioning ${package} ... "
        # If any config exists, source it.
        if [ -f "$package_path/config.sh" ] ; then
            source "$package_path/config.sh"
        fi

        # Source the actual package.
        if [ -f "$package_path/package.sh" ] ; then
            source "$package_path/package.sh"
        fi
    done

    if [ -f ${VPB_ROOT}/post_provision.sh ] ; then
        source ${VPB_ROOT}/post_provision.sh
    fi
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
        ln -sF /vagrant/.vpb/packages/"${package}" .vpb/enabled/
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
