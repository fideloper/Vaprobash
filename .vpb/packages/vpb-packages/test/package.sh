#!/usr/bin/env bash

configure() {
    msg "Configuring a test package"

    msg "What is your name? "
    read name

    msg "Hello ${name}"
}

install() {
    msg "installing a test package"
}
