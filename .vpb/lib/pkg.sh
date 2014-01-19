#!/usr/bin/env bash
#
# This file is the start of the pkg framework.
#
vpb.pkg.extends() {
    package="$1"

    if [ -f "${VPB_ROOT}/packages/${package}/package.sh" ] ; then
        source ${VPB_ROOT}/packages/${package}/package.sh
    fi
}
