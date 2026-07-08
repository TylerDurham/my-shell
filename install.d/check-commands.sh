#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

declare -A CMDS=(
  ["bat"]="bat"
  ["fzf"]="fzf"
  ["git"]="git"
  ["lsd"]="lsd"
  ["nvim"]="neovim"
  ["rg"]="ripgrep"
  ["stow"]="stow"
  ["tree"]="tree"
  ["zoxide"]="zoxide"
 )

 for KEY in ${!CMDS[@]}; do 
   CMD="${CMDS[$KEY]}"
   if ! command -v "$CMD" &>/dev/null; then
    warn "$KEY: $CMD"
   fi
 done
