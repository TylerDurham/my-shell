#!/usr/bin/env bash

UNINSTALL=
readonly REPO_ROOT=$(git rev-parse --show-toplevel)
INSTALL_ROOT="$REPO_ROOT/install.d/arch"
readonly export MY_BIN_DIR="$REPO_ROOT/dotfiles/.local/share/my/bin"

export PATH="$MY_BIN_DIR:$PATH"

# ensure we are on arch linux
OS=$(sys-get-os)
[[ "$OS" == "arch" || "$OS" == "cachyos" ]] || {
    echo "$OS is not an arch derivative! exiting"
    exit 1
}

check-command() {
    command -v "$1" &>/dev/null && return 0 || return 1
}

check-package() {
    yay -Q "$1" &>/dev/null && return 0 || return 1
}

# console logging
debug() {
    gum log -l debug "$@"
}


info() {
    gum log -l info "$@"
}

warn() {
    gum log -l warn "$@"
}

indent() {
    local foo=1
}

if ! check-command "gum"; then
    echo "'gum' is used for pretty console logging. installing now..."
    sudo pacman -Sy --noconfirm gum
    clear
    info "'gum' installed! that's more like it..."
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--remove) UNINSTALL=1; shift ;;
        *) shift ;;
    esac
done

readonly modules=(
    packages.sh
    yay.sh
    git.sh
)

for module in "${modules[@]}"; do
    source "$INSTALL_ROOT/$module"

    on_init
    
    if [[ "$UNINSTALL" == 1 ]]; then
        on_uninstall
    else
        on_install
    fi
done
