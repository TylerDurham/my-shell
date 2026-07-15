# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles for Bash, Zsh, tmux, and Ghostty — designed to work across macOS, Arch Linux, Ubuntu, Fedora, and NixOS. Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink everything under `$HOME`.

## Install / Uninstall

```bash
./setup          # install everything (runs install.d/* in order)
./setup -r       # revert to pre-install backups
```

Each module in `install.d/` can also be run standalone with the same `-r` flag.

## How Stow Works Here

`stow.sh` runs `stow --no-folding --dir $PROJECT_ROOT -S . -t $HOME`, which mirrors the repo's directory tree directly into `$HOME`. That means:

- `.config/tmux/tmux.conf` in the repo → `~/.config/tmux/tmux.conf` symlink
- `.local/share/my/bin/` in the repo → `~/.local/share/my/bin/` symlinks

When editing a dotfile, the real file is always here in the repo; the path under `~/.config` is a symlink.

## Key Environment Variables

Set by `shared.envs.sh` and available in all shell sessions after install:

| Variable | Value |
|---|---|
| `MY_BIN_DIR` | `~/.local/share/my/bin` |
| `MY_LIB_DIR` | `~/.local/share/my/lib` |
| `MY_CONFIG_DIR` | `~/.config/my` |
| `OLLAMA_HOST` | `https://ollama.snork.co` (override via `~/ollama.env.sh`) |

## Bash Library Conventions

### `require.sh` — module loader

```bash
source "$PROJECT_ROOT/.local/share/my/lib/bash/require.sh" logger
```

Resolves modules by name from `$MY_LIB_DIR/bash/`. Safe to call multiple times — each module is sourced at most once per session via guard variables.

### `logger.sh` — leveled logging

Controlled by `LOG_LEVEL` (default: `4` = INFO and above after install).

```bash
debug "..."   # level 8
info  "..."   # level 4
warn  "..."   # level 2
error "..."   # level 1
fatal "..."   # level 0 — exits 1
```

Style helpers for ad-hoc output: `bold_green`, `dim`, `red`, etc. Colors are auto-disabled when stdout is not a terminal.

### Pattern: UI-Aware Top-Level Scripts

Top-level scripts own the notification layer. Child scripts write freely to stdout/stderr. The pattern:

```bash
#!/usr/bin/env bash

on_exit() {
  (( $? > 0 )) && notify-send "ERROR" "$msg" || notify-send "Done" "$msg"
}

set -euEo pipefail
trap on_exit EXIT

source "$PROJECT_ROOT/.local/share/my/lib/bash/logger.sh"
msg=""  # initialize before any failable command so trap is always safe
msg=$(some-child-script "$@" 2>&1)
```

## `bin/` Script Conventions

Scripts use `sys-get-os` to branch on platform (`arch`, `ubuntu`, `macos`, `fedora`, etc.). Cross-platform installs go through `sys-pkg-install` / `sys-pkg-check` / `sys-pkg-uninstall` rather than calling `apt`, `pacman`, or `brew` directly.

## Tmux

Reload config: `prefix + r` (displays a status message on success).

`tpm.sh` bootstraps TPM if not installed. Plugin list lives in `tmux.conf`.

## Ghostty

Machine-local overrides go in `~/.config/ghostty/local.ghostty` (gitignored). The auto-loaded theme is at `.config/ghostty/auto/theme.ghostty`.
