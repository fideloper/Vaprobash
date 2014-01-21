#!/usr/bin/env bash
#
# This file acts as something of a router. Dispatching
# requests of to the various actions.
#

vpb.router() {
    action="$1"

    # Remove the action name from the arguments list.
    shift
    case "$action" in
        provision)
            # Safeguard to prevent provisioning the host machine.
            if vpb.util.is_vm ; then
                vpb.controller.provision
            else
                die "provision should not be called from within the host system"
            fi
            ;;
        available)
            vpb.controller.available
            ;;
        enabled)
            vpb.controller.enabled
            ;;
        enable)
            vpb.controller.enable "$@"
            ;;
        disable)
            vpb.controller.disable "$@"
            ;;
        configure)
            vpb.controller.configure "$@"
            ;;
        fetch)
            vpb.controller.fetch "$@"
            ;;
        help|*)
            vpb.controller.usage
            exit 1
            ;;
    esac
}
