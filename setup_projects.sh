#!/usr/bin/env bash

chmod -R u+x ./project_setup_scripts

for file in ./project_setup_scripts/*.sh; do
    [ -f "$file" ] && [ -x "$file" ] && "$file";
done
