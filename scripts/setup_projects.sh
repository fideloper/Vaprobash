#!/usr/bin/env bash

chmod -R u+x ./projects

for file in ./projects/*.sh; do
    [ -f "$file" ] && [ -x "$file" ] && "$file";
done
