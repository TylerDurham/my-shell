#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

if [[ "$(sys-get-os)" == "nixos" ]]; then
  warn "No need to configure 'git' on NixOs."
  exit 0
fi

GIT_CONFIGS=(
  "user.name:Tyler Durham"
  "user.email:TylerDurham@noreply.users.github.com"
  "init.defaultBranch:master"
  "core.editor:nvim"
  "push.autoSetupRemote:true"
  "fetch.prune:true"
  "rerere.enabled:true"
  "tag.gpgSign:true"
)

if [[ -z "$REVERT" ]]; then
  for ENTRY in "${GIT_CONFIGS[@]}"; do
    KEY="${ENTRY%%:*}"
    VALUE="${ENTRY#*:}"
    info "Setting '$KEY' = '$VALUE'..."
    git config --global "$KEY" "$VALUE"
  done
else
  for ENTRY in "${GIT_CONFIGS[@]}"; do
    KEY="${ENTRY%%:*}"
    warn "Unsetting '$KEY'..."
    git config --global --unset "$KEY"
  done
fi
