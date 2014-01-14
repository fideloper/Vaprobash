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
# TODO: Filter enabled packages from this list
vpb.list() {
    ls ${VPB_ROOT}/packages
}

# Enable a package
vpb.enable() {
    if [ -d ${VPB_ROOT}/packages/"$1" ] ; then
        ln -sF /vagrant/.vpb/packages/"$1" .vpb/enabled/
    fi
}

# Disable a package
vpb.disable() {
    if [ -L ${VPB_ROOT}/enabled/"$1" ] ; then
        rm ${VPB_ROOT}/enabled/"$1"
    fi
}
