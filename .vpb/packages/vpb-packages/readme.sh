#!/usr/bin/env bash

for pkg in * ; do
    echo "# $pkg" >> $pkg/README.md
    echo "" >> $pkg/README.md

    if [ -f $pkg/config.sh ] ; then
        echo "## Config" >> $pkg/README.md
        echo "" >> $pkg/README.md
        cat $pkg/config.sh >> $pkg/README.md
    fi
done
