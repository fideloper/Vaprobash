#!/usr/bin/env bash

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

# Exposed globally
col() { vpb.echo log "${@}" | column -x -c 80; }
log() { vpb.echo log "${@}"; }
msg() { vpb.echo msg "${@}"; }
success() { vpb.echo success "${@}"; }
warn() { vpb.echo warn "${@}"; }
error() { vpb.echo error "${@}" >&2; }
die() { error "$@"; exit 1; }
try() { "$@" || die "fatal: $@"; }
###

vpb.util.is_vm() {
    [[ -n $VPB_IN_VM ]]
}

vpb.util.is_default_vendor() {
    [[ "$1" = "${VPB_DEFAULT_VENDOR:=fideloper}" ]]
}

vpb.util.has() {
    local v=$1;
    shift
    echo "$@" | grep -q "$v"
}

vpb.util.get_enabled() {
    for pkg in ${VPB_ROOT}/enabled/* ; do
        echo "${pkg##*/}"
    done
}

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

vpb.util.get_vendors() {
    for vendor in ${VPB_ROOT}/packages/* ; do
        echo "${vendor##*/}"
    done
}

vpb.util.exec_hook() {
    hook="$1"
    if [ -f ${VPB_ROOT}/../hooks/${hook}.sh ] ; then
        source ${VPB_ROOT}/../hooks/${hook}.sh
    fi
}
