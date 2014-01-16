#!/usr/bin/env bash
#
# This file acts as something of a router. Dispatching
# requests of to the various actions.
#

vpb.main() {
    action="$1"

    # Remove the action name from the arguments list.
    shift
    case "$action" in
        provision)
            # Safeguard to prevent provisioning the host machine.
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
            vpb.enable "$@"
            ;;
        disable)
            vpb.disable "$@"
            ;;
        configure)
            vpb.configure "$@"
            ;;
        fetch)
            vpb.fetch "$@"
            ;;
        help|*)
            vpb.usage
            exit 1
            ;;
    esac
}
