#!/usr/bin/env bash
#
# This file acts as something of a router. Dispatching
# requests of to the various actions.
#

vpb.router() {
    local action="$1"

    # Remove the action name from the arguments list.
    shift
    case "$action" in
        provision)
            vpb.controller.provision "$@"
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
        readme)
            vpb.controller.readme "$@"
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
