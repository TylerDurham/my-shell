# ==============================================================================
# LOAD ENVs
# ==============================================================================

source "$HOME/.local/share/my/shell/shared.envs.sh"
source "$MY_INSTALL_DIR/shell/shared.aliases.sh"

if command -v starship >& /dev/null; then
  eval "$(starship init bash)"
fi

# MISE
if command -v mise >& /dev/null; then
  if [[ -z "$MISE_SHELL" ]]; then
    eval "$(mise activate zsh)"
  fi
fi



