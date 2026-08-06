#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

if [[ "$(sys-get-os)" == "nixos" ]]; then
  warn "No need to configure 'git' on NixOs."
  exit 0
fi

# 1Password's SSH signing helper lives in the app bundle on macOS.
if [[ "$(sys-get-os)" == "macos" ]]; then
  OP_SSH_SIGN="/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
else
  OP_SSH_SIGN="/opt/1Password/op-ssh-sign"
fi

GIT_CONFIGS=(
  "user.name:Tyler Durham"
  "user.email:2191002+TylerDurham@users.noreply.github.com"
  "user.signingkey:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIF0MyXTqMTH4SoUBocralanLGXtymmBxTc5t7cwi9mI"
  "init.defaultBranch:master"
  "core.editor:nvim"
  "core.pager:bat"
  "push.autoSetupRemote:true"
  "fetch.prune:true"
  "rerere.enabled:true"
  "tag.gpgSign:true"
  "commit.gpgsign:true"
  "gpg.format:ssh"
  "gpg.ssh.program:$OP_SSH_SIGN"
  "gpg.ssh.allowedSignersFile:$HOME/.config/git/allowed_signers"
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
