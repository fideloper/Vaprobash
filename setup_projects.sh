#!/usr/bin/env bash

# Loop over bash scripts to set-up projects.
#
# See notes/references below:
#
# http://mywiki.wooledge.org/BashPitfalls#line-80
# https://stackoverflow.com/a/43606356
for FILE in project_setup_scripts/*.sh; do
    [ -e $FILE ] || continue
	(bash -n $FILE) &
done