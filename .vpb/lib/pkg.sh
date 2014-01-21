#!/usr/bin/env bash
#
# This file is the start of the pkg framework.
#

#
# Extend a package by sourcing its contents.
#
# We dont use vpb.pkg.source here becuase it would define the
# wrong pkg_* variables.
#
vpb.pkg.extends() {
    package=($(vpb.util.resolve_package "$1"))

    if [ $? = 0 ] ; then
        source "${package[2]}/package.sh"
    fi
}

# Write a config option
vpb.pkg.config() {
    package="$1"; option="$2"; value="$3"
    package_dir="${VPB_ROOT}/packages/$(vpb.util.resolve_package $package)"
    if [ -d "${package_dir}" ] ; then
        conf_file=${package_dir}/config.sh
        if ! [ -f "${conf_file}" ] ; then
            touch "${conf_file}"
        fi

        # If the option exists in the file we need to update it.
        if grep -q "^${option}" "${conf_file}" ; then
            sed -i -e "s/${option}=\".*\"/${option}=\""${value}\""/g" $conf_file

        # Otherwise, add it.
        else
            echo "${option}=\"${value}\"" >> $conf_file
        fi
    fi
}
