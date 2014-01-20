#!/usr/bin/env bash
#
# This file is the start of the pkg framework.
#

#
# Extend a package by sourcing its contents.
#
# We dont use vpb.pkg.source here becuase it would define the
# wrong pkg_* variables.
#
vpb.pkg.extends() {
    package=($(vpb.pkg.resolve "$1"))

    if [ $? = 0 ] ; then
        source "${package[2]}/package.sh"
    fi
}

#
# Resolve a package by name or path. If a name is supplied without a vendor
# this function will attempt to resolve that within the default vendor.
#
# If the package resolves and a package.sh file is found this function
# will return a list containing (in this order) the vendor, package name
# and path to the package root.
#
vpb.pkg.resolve() {
    # Do we have a symlink ?
    if [ -L "$1" ] ; then
        path=$(ls -l "$1" | awk '{print $11}')
        parts="${path#*packages/*}"
        vendor=${parts%%/*}
        package="${parts##*/}"

        # This may be running from within the host so strip /vagrant/ if required.
        if [ -d "$path" ] || [ -d "${path##*vagrant/}" ] ; then
            echo "$vendor $package $path"
            return 0
        fi
    fi

    # Do we have a package directory ?
    if [ -d "$1" ] ; then
        path="$1"
        parts="${path#*packages/*}"
        vendor=${parts%%/*}
        package="${parts##*/}"

        echo "$vendor $package $path"

        if [ -d "$path" ] ; then
            echo "$vendor $package $path"
            return 0
        fi
    fi

    # Do we have a package name including a vendor: prefix ?
    if [[ "$1" = *:* ]] ; then
        vendor=${1%%:*}
        package="${1##*:}"
        path="${VPB_ROOT}/packages/${vendor}/${package}"
        if [ -d "$path" ] ; then
            echo "$vendor $package $path"
            return 0
        fi
    fi

    # Do we have a package name including a vendor/ prefix ?
    if [[ "$1" = */* ]] ; then
        vendor=${1%%/*}
        package="${1##*/}"
        path="${VPB_ROOT}/packages/${vendor}/${package}"
        if [ -d "$path" ] ; then
            echo "$vendor $package $path"
            return 0
        fi
    fi

    # Do we have a default vendor package ?
    vendor="${VPB_DEFAULT_VENDOR:=fideloper}"
    package="${1}"
    path="${VPB_ROOT}/packages/${vendor}/${package}"
    if [ -d "$path" ] ; then
        echo "$vendor $package $path"
        return 0
    fi

    # Could not resolve package
    return 1
}

#
# Resolve a package by name and source a file within it.
# Sources the package.sh by default.
#
vpb.pkg.source() {
    package=($(vpb.pkg.resolve "$1"))

    if [ $? = 0 ] ; then
        pkg_vendor=${package[0]}
        pkg_name=${package[1]}
        pkg_path=${package[2]}

        echo "$pkg_vendor $pkg_name $pkg_path"

        if [ $# = 2 ] ; then
            if [ -f "${pkg_path}/$2.sh" ] ; then
                source "${pkg_path}/$2.sh"
            fi
        else
            source "${pkg_path}/package.sh"
        fi
    else
        echo "$1 not found"
    fi
}
