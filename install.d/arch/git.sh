#!/usr/bin/env bash

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

on_init() {

  info "initializing module '$(basename ${BASH_SOURCE[0]})'"
  # # Modules are sourced in their own subshell, so exiting here skips the
  # # install/uninstall hook without failing the run.
  # if [[ "$(sys-get-os)" == "nixos" ]]; then
  #   warn "No need to configure 'git' on NixOs." 2>&1 | indent
  #   return 1
  # fi
}

on_install() {
  info "installing module '$(basename ${BASH_SOURCE[0]})'"
  local entry key value

  for entry in "${GIT_CONFIGS[@]}"; do
    key="${entry%%:*}"
    value="${entry#*:}"
    debug "Setting '$key' = '$value'..."
    git config --global "$key" "$value"
  done
}

on_uninstall() {
  info "uninstalling module '$(basename $BASH_SOURCE[0])'"
  local entry key

  for entry in "${GIT_CONFIGS[@]}"; do
    key="${entry%%:*}"
    debug "Unsetting '$key'..." 2>&1 | indent
    git config --global --unset "$key" || true
  done
}

on_completed() {
  info "'$(basename ${BASH_SOURCE[0]})' completed!"
}

