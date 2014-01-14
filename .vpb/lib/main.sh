#!/usr/bin/env bash

vpb.main() {
    case "${1}" in
        provision)
            if vpb.is_vm ; then
                vpb.provision
            else
                warn "provision should not be called from within the host system"
            fi
            ;;
        list)
            vpb.list
            ;;
        enable)
            vpb.enable "$2"
            ;;
        disable)
            vpb.disable "$2"
            ;;
        configure)
            msg "Not yet implemented"
            #vpb.configure "$2"
            ;;
        *)
            vpb.usage
            exit 1
            ;;
    esac
}
