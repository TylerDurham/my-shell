#!/usr/bin/env bash

packages=(
  bun
  gh
  go
  gopls
  just
  lazygit
  lsd
  mise
  neovim
  node
  prettier
  black
  isort
  starship
  stow
  stylua
  tree
  tree-sitter
  uv
  zoxide
)

# macOS ships older system copies of these; install the Homebrew versions
packages+=(fzf)
packages+=(git)
packages+=(python)
packages+=(vim)
packages+=(zsh)

on_init() {
  info "initializing module '$(basename "${BASH_SOURCE[0]}")'"
}

on_install() {
  info "installing module '$(basename "${BASH_SOURCE[0]}")'"
  for package in "${packages[@]}"; do
    if ! check-package "$package"; then
      info "installing package '$package'..."
      brew install --quiet "$package"
    else
      warn "package '$package' already installed... skipping"
    fi
  done
}

on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"
  for package in "${packages[@]}"; do
    if check-package "$package"; then
      brew uninstall "$package"
    else
      warn "package '$package' is not installed... skipping"
    fi
  done
}

on_completed() {
  info "module '$(basename $module)' completed!"
}
