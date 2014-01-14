#!/usr/bin/env bash

vpb.is_vm() {
    [[ -n $VPB_IN_VM ]]
}

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
log() { vpb.echo log "${@}"; }
msg() { vpb.echo msg "${@}"; }
success() { vpb.echo success "${@}"; }
warn() { vpb.echo warn "warning: ${@}"; }
error() { vpb.echo error "error: ${@}" >&2; }
die() { error "$@"; exit 1; }
try() { "$@" || die "fatal: $@"; }
