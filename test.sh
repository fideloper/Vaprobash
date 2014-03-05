#! /usr/bin/env bash

for file in $(find ./scripts -name '*.sh'); do
    bash -n $file
done

