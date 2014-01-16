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

# Resolve a package name taking into account the default vendor
# eg;
# foo     = default/foo
# foo:bar = foo/bar
vpb.util.resolve_package() {
    if [[ "$1" = *:* ]] ; then
        vendor=${1%%:*}
        echo "$vendor/${1##*:}"
    else
        echo "${VPB_DEFAULT_VENDOR:=fideloper}/$1"
    fi
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
