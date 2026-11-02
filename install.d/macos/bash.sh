
if [[ "$(sys-get-os)" == "nixos" ]]; then
  warn "No need to configure 'bash' on NixOs."
  exit 0
fi

TARGET="$HOME/.bashrc"
BACKUP="$TARGET.backup"

# macOS ships bash 3.2 at /bin/bash, which SIP prevents replacing. Instead,
# link Homebrew's bash into /usr/local/bin (ahead of /bin in /etc/paths) so
# '#!/usr/bin/env bash' resolves to it everywhere, and register it as a shell.
BREW_BASH="${HOMEBREW_PREFIX:-$(brew --prefix)}/bin/bash"
BASH_LINK="/usr/local/bin/bash"
SHELLS="/etc/shells"
SHELLS_BACKUP="$SHELLS.backup"

on_init() {
  info "initializing module '$(basename ${BASH_SOURCE[0]})'"
}

on_install() {
  info "installing module '$(basename "${BASH_SOURCE[0]}")'"
  if ! check-package "bash"; then
    debug "installing homebrew 'bash'..."
    brew install --quiet bash
  fi
  debug "linking homebrew 'bash'..."
  brew link --overwrite bash

  if [[ "$BREW_BASH" != "$BASH_LINK" ]]; then
    debug "symlinking '$BASH_LINK' -> '$BREW_BASH'..."
    sudo mkdir -p "$(dirname "$BASH_LINK")"
    sudo ln -sf "$BREW_BASH" "$BASH_LINK"
  fi

  if ! grep -qxF "$BREW_BASH" "$SHELLS"; then
    debug "'$SHELLS' exists... backing up to '$SHELLS_BACKUP'..."
    sudo cp "$SHELLS" "$SHELLS_BACKUP"
    debug "registering '$BREW_BASH' in '$SHELLS'..."
    echo "$BREW_BASH" | sudo tee -a "$SHELLS" >/dev/null
  fi

  debug "overwriting '$TARGET'..."
  if [[ -f "$TARGET"  ]]; then
    debug "'$TARGET' exists... backing up to '$BACKUP'..."
    mv $TARGET $BACKUP
  fi
  echo "source ~/.local/share/my/shell/bash.rc.sh" > $TARGET
}

on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"
  if [[ -L "$BASH_LINK" && "$(readlink "$BASH_LINK")" == "$BREW_BASH" ]]; then
    debug "removing symlink '$BASH_LINK'..."
    sudo rm "$BASH_LINK"
  fi
  if [[ -f "$SHELLS_BACKUP" ]]; then
    debug "restoring '$SHELLS' from '$SHELLS_BACKUP'..."
    sudo mv $SHELLS_BACKUP $SHELLS
  fi
  if [[ -f "$BACKUP" ]]; then
    debug "restoring '$TARGET' from '$BACKUP'..."
    mv $BACKUP $TARGET
  fi
}

on_completed() {
  info "'$(basename ${BASH_SOURCE[0]})' completed!"
}

