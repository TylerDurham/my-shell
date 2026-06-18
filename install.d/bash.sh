#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

TARGET="$HOME/.bashrc"
BACKUP="$TARGET.backup"

if [[ -z "$REVERT" ]]; then
  info "Overwriting '$TARGET'..."
  if [[ -f "$TARGET"  ]]; then 
    warn "'$TARGET' exists... backing up to '$BACKUP'..."
    mv $TARGET $BACKUP
  fi
  echo "source ~/.local/share/$PREFIX/shell/zsh.rc.sh" > $TARGET
else
  if [[ -f "$BACKUP" ]]; then
    info "Restoring '$TARGET' from '$BACKUP'..."
    mv $BACKUP $TARGET
  fi
fi

