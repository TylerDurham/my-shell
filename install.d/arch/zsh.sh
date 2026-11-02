# if [[ "$(sys-get-os)" == "nixos" ]]; then
#   warn "No need to configure 'zsh' on NixOs."
#   exit 0
# fi

TARGET="$HOME/.zshrc"
BACKUP="$TARGET.backup"

on_init() {
  info "initializing module '$(basename ${BASH_SOURCE[0]})'"
}

on_install() {
  info "installing module '$(basename ${BASH_SOURCE[0]})'"
  debug "overwriting '$TARGET'..."
  if [[ -f "$TARGET" ]]; then
    debug "'$TARGET' exists... backing up to '$BACKUP'..."
    mv $TARGET $BACKUP
  fi
  echo "source ~/.local/share/my/shell/zsh.rc.sh" >$TARGET
}

on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"
  if [[ -f "$BACKUP" ]]; then
    debug "restoring '$TARGET' from '$BACKUP'..."
    mv $BACKUP $TARGET
  fi
}

on_completed() {
  info "'$(basename ${BASH_SOURCE[0]})' completed!"
}
