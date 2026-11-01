#!/usr/bin/env bash

packages=(
    git
    gum
    lsd
    stow
    tree
    zoxide
    zsh
)

on_init() {

}

on_install() {
    for package in "${packages[@]}"; do
        info "installing package '$package'"
    done
}

on_uninstall() {

}
