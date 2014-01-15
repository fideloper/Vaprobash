#!/usr/bin/env bash

vpb.main() {
    case "${1}" in
        provision)
            if vpb.util.is_vm ; then
                vpb.provision
            else
                warn "provision should not be called from within the host system"
            fi
            ;;
        available)
            vpb.available
            ;;
        enabled)
            vpb.enabled
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
        fetch)
            vpb.fetch "$2" "$3"
            ;;
        *)
            vpb.usage
            exit 1
            ;;
    esac
}
