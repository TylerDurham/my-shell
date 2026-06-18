#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

DIRECTORIES=(
  "$HOME/.local/share/$PREFIX/bin"
  "$HOME/.local/share/$PREFIX/lib"
  "$HOME/.local/share/$PREFIX/shell"
  "$HOME/.config/$PREFIX"
)

for DIR in "${DIRECTORIES[@]}"; do
  if [[ -z "$REVERT" ]]; then
    info "Creating directory at '$DIR'..."
    mkdir -p "$DIR"
    touch "$DIR/kilroy"
  else
    warn "Removing directory at '$DIR'..."
    rm -rf "$DIR"
  fi
done
