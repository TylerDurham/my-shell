#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

# macOS ships bash 3.2 at /bin/bash (last GPLv2 release) and never updates it.
# Scripts that use bash 4+ features (e.g. associative arrays, like
# sys-get-os-icon) silently break under it. Homebrew's bash sits at
# /opt/homebrew/bin (or /usr/local/bin on Intel), which is already ahead of
# /bin on PATH, so installing it is enough for `#!/usr/bin/env bash` scripts
# to pick up the modern version without changing anyone's login shell.

if [[ "$(uname -s)" != "Darwin" ]]; then
  warn "Not on macOS, skipping bash upgrade..."
  exit 0
fi

if ! command -v brew &>/dev/null; then
  fatal "Homebrew not found. Install it from https://brew.sh first."
fi

BREW_PREFIX="$(brew --prefix)"
BREW_BASH="$BREW_PREFIX/bin/bash"

if [[ -z "$REVERT" ]]; then
  if brew list bash &>/dev/null; then
    info "Upgrading Homebrew bash..."
    brew upgrade bash
  else
    info "Installing Homebrew bash..."
    brew install bash
  fi

  if ! grep -qx "$BREW_BASH" /etc/shells 2>/dev/null; then
    info "Registering '$BREW_BASH' in /etc/shells (requires sudo)..."
    echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null
  fi

  ok "$($BREW_BASH --version | head -1)"
else
  if brew list bash &>/dev/null; then
    warn "Uninstalling Homebrew bash..."
    brew uninstall bash
  fi

  if grep -qx "$BREW_BASH" /etc/shells 2>/dev/null; then
    warn "Removing '$BREW_BASH' from /etc/shells (requires sudo)..."
    sudo sed -i '' "\|^${BREW_BASH}\$|d" /etc/shells
  fi
fi
