# Keep GNU stow from owning these directories
DIRECTORIES=(
  "$HOME/.local/share/$PREFIX/bin"
  "$HOME/.local/share/$PREFIX/lib/bash"
  "$HOME/.local/share/$PREFIX/shell/hooks/"{envs,boot}
  "$HOME/.config/$PREFIX"
  "$HOME/.claude/commands"
)

on_init() {
  info "initializing module '$(basename $0)'"
}

on_install() {
  info "installing module '$(basename $0)'"
  for dir in "${DIRECTORIES[@]}"; do
    debug "creating directory at '$dir'..."
    mkdir -p "$dir"
  done
}

on_uninstall() {
  info "uninstalling module '$(basename $0)'"
  for dir in "${DIRECTORIES[@]}"; do
    warn "removing directory at '$dir'..." 2>&1 | indent
    rm -rf "$dir"
  done
}

on_completed() {
  info "'$(basename ${BASH_SOURCE[0]})' completed!"
}

