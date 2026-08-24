#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/install.d/envs.sh"

init "$@"

MODULES=(
  "dev/mise.sh"
  "dev/nodejs.sh"
)

# Reverting walks the list backwards so teardown undoes things in the reverse
# order they were set up — e.g. 'dev/nodejs.sh' still has a working 'mise' to
# uninstall node with when 'dev/mise.sh' removes the binary right after.
if [[ -z "$REVERT" ]]; then
  ORDER=("${MODULES[@]}")
else
  ORDER=()
  for (( i=${#MODULES[@]}-1; i>=0; i-- )); do
    ORDER+=("${MODULES[$i]}")
  done
fi

for MOD in "${ORDER[@]}"; do
  CMD="$MY_INSTALL_DIR/install.d/$MOD"
  if [[ -z "$REVERT" ]]; then
    info "Installing module '$CMD'..."
    $CMD
  else
    warn "Reverting module '$CMD'..."
    $CMD -r
  fi
done

