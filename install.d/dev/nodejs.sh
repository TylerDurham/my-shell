#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

# Node is installed through mise rather than a system package manager, so the
# version is the same everywhere and upgrades don't fight with apt/pacman/brew.
# `node = "latest"` is written to the global config (~/.config/mise/config.toml)
# as a fuzzy version, so re-running this script picks up newer releases.

if [[ "$(sys-get-os)" == "nixos" ]]; then
  warn "No need to install 'nodejs' on NixOs."
  exit 0
fi

MISE_BIN="${MISE_INSTALL_PATH:-$HOME/.local/bin/mise}"

if [[ ! -x "$MISE_BIN" ]]; then
  fatal "'mise' not found at '$MISE_BIN'. Run '$CWD/mise.sh' first."
fi

if [[ -z "$REVERT" ]]; then
  info "Installing 'node@latest' via mise..."
  "$MISE_BIN" use --global --yes node@latest

  ok "node $("$MISE_BIN" exec -- node --version), npm $("$MISE_BIN" exec -- npm --version)"
else
  warn "Removing 'node' from the global mise config..."
  "$MISE_BIN" use --global --remove node

  warn "Uninstalling all 'node' versions..."
  "$MISE_BIN" uninstall --all node
fi
