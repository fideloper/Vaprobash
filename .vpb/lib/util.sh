#!/usr/bin/env bash
#
# This file contains utility functions. Most are very specific to
# this particular application, while others a fairly generic. This
# file exists to keep the lib.sh script cleaner - containing mostly
# business logic.
#

# Formatted echo.
vpb.echo() {
    local color=
    case $1 in
        msg)
            color='\033[00;36m'
            ;;
        success)
            color='\033[00;32m'
            ;;
        warn)
            color='\033[00;33m'
            ;;
        error)
            color='\033[00;31m'
            ;;
        log)
            color=
            ;;
    esac
    shift

    echo -e "${color}$@\033[0m"
}

# Globally exposed formatted output.
col()     { vpb.echo log "${@}" | column -x -c 80; }
log()     { vpb.echo log "${@}"; }
msg()     { vpb.echo msg "${@}"; }
success() { vpb.echo success "${@}"; }
warn()    { vpb.echo warn "${@}"; }
error()   { vpb.echo error "${@}" >&2; }
die()     { error "$@"; exit 1; }

# Try catch?
try() { "$@" || die "fatal: $@"; }

# Check to see if we are within a vagrant vm
vpb.util.is_vm() {
    [[ -n $VPB_IN_VM ]]
}

# Check a vendor name is the default vendor
vpb.util.is_default_vendor() {
    [[ "$1" = "${VPB_DEFAULT_VENDOR:=fideloper}" ]]
}

# Does a list contain a value?
vpb.util.has() {
    local v=$1;
    shift
    echo "$@" | grep -q "$v"
}

# Get a list of enabled packages.
vpb.util.get_enabled() {
    for pkg in ${VPB_ROOT}/enabled/* ; do
        echo "${pkg##*/}"
    done
}

# get a list of available packages within a vendor repo
vpb.util.get_available() {
    vendor="$1"
    if [ -d ${VPB_ROOT}/packages/${vendor} ] ; then
        for pkg in ${VPB_ROOT}/packages/${vendor}/* ; do
            pkg="${pkg##*/}"
            if ! vpb.util.has "${pkg}" $(vpb.util.get_enabled) ; then
                echo "${pkg}"
            fi
        done
    else
        warn "The vendor ${vendor} does not exist"
    fi
}

# Get a list of all vendors.
vpb.util.get_vendors() {
    for vendor in ${VPB_ROOT}/packages/* ; do
        echo "${vendor##*/}"
    done
}

# Execute a hook.
# Hooks are executed in non-interactive mode.
vpb.util.exec_hook() {
    VPB_NONINTERACTIVE=true
    hook="$1"
    if [ -f ${VPB_ROOT}/../hooks/${hook}.sh ] ; then
        source ${VPB_ROOT}/../hooks/${hook}.sh
    fi
    unset VPB_NONINTERACTIVE
}

# Does a function exist?
vpb.util.func_exists() {
    type -t "$1" | grep -q "function"
}

# Execute a variable function then remove it from the current environment.
vpb.util.exec_func() {
    func="$1"
    shift
    if vpb.util.func_exists "${func}" ; then
        ${func} $@
        unset "${func}"
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
vpb.util.resolve_package() {
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
vpb.util.source_package() {
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
