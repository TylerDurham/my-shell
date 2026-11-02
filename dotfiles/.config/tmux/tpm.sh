#!/usr/bin/env bash

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [[ -d "$TPM_DIR/.git" ]]; then
  echo "tpm installed already."
else
  mkdir -p "$(dirname "$TPM_DIR")"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
