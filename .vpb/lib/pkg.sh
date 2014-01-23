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
    local package=

    if package=($(vpb.util.resolve_package "$1")) ; then

        local pkg_vendor=${package[0]}
        local pkg_name=${package[1]}
        local pkg_path=${package[2]}
        
        source "${pkg_path}/package.sh"
    fi
}

# Write a config option
vpb.pkg.config() {
    local package=

    if package=($(vpb.util.resolve_package "$1")) ; then

        local pkg_vendor=${package[0]}
        local pkg_name=${package[1]}
        local pkg_path=${package[2]}

        local option="$2";
        local value="$3"
        local conf_file="${pkg_path}/config.sh"

        if ! [ -f "${conf_file}" ] ; then
            touch "${conf_file}"
        fi

        # If the option exists in the file we need to update it.
        if grep -q "^${option}" "${conf_file}" ; then
            sed -i -e "s/${option}=\".*\"/${option}=\""${value}\""/g" "$conf_file"

        # Otherwise, add it.
        else
            echo "${option}=\"${value}\"" >> "$conf_file"
        fi
    fi
}

# Check to see if a configure function exists in the package file.
# We can't just source the file and see if it is defined because this
# will potentially trigger provisioning in the older legacy scripts
# that have all there code in the global namespace.
vpb.pkg.has_configure() {
    local package=

    if package=($(vpb.util.resolve_package "$1")) ; then

        local pkg_vendor=${package[0]}
        local pkg_name=${package[1]}
        local pkg_path=${package[2]}

        grep -q "^configure()" "${pkg_path}/package.sh"
    fi
}
