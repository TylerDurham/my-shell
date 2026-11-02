# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles for Bash, Zsh, tmux, and Ghostty — designed to work across macOS, Arch Linux, Ubuntu, Fedora, and NixOS. Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink everything under `$HOME`.

## Install / Uninstall

```bash
./install        # install everything
./install -r     # uninstall, reverting to pre-install backups
./install -s     # pick modules interactively
```

`./install` is a thin bootstrap: it detects the OS with `sys-get-os` and execs `install.d/<os>/install` (`macos`, or `arch` for arch/cachyos/endeavour/manjaro), passing options through unchanged. It must stay bash 3.2 compatible, since stock macOS runs it before Homebrew bash exists.

Each per-OS `install` sources the `*.sh` modules in its directory and calls their `on_init`, `on_install`/`on_uninstall` and `on_completed` hooks (reverse order on `-r`). The per-OS `install` can be run directly with the same flags; individual modules cannot, since they rely on the helpers it defines.

## How Stow Works Here

Everything that gets linked into `$HOME` lives under `dotfiles/`. The `stow.sh` module in each `install.d/<os>/` runs `stow --no-folding --dir "$REPO_ROOT/dotfiles" -S . -t "$HOME"` (and `-D` on uninstall), which mirrors `dotfiles/` directly into `$HOME`. That means:

- `dotfiles/.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf` symlink
- `dotfiles/.local/share/my/bin/` → `~/.local/share/my/bin/` symlinks

`--no-folding` makes stow link individual files rather than whole directories, so real directories are created under `$HOME` and tool-generated files (plugins, caches, state) land there instead of in the repo. Files at the repo root (`install`, `install.d/`, `README.md`, …) sit outside `dotfiles/` and are never stowed.

When editing a dotfile, edit it under `dotfiles/` in the repo; the path under `$HOME` is a symlink to it.

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
source "$MY_LIB_DIR/bash/require.sh" logger
```

Resolves modules by name from `$MY_LIB_DIR/bash/`. Safe to call multiple times — each module is sourced at most once per session via guard variables.

### `logger.sh` — logging, color, and layout

Log helpers write to **stderr**; every other helper writes to stdout with **no trailing newline**, so they compose inside `$(...)` and pipelines.

```bash
info    "..."   # [INFO]
warn    "..."   # [WARNING]
error   "..."   # [ERROR]
debug   "..."   # [DEBUG]
success "..."   # [OK]   — alias: ok
fatal 2 "..."   # [FATAL] — exits with the status in $1 (required, must be numeric)
```

Each has a `_badge` variant (`info_badge`, `error_badge`, …) that prefixes a colored chip instead of a bracketed label.

Only `debug` is gated on `LOG_LEVEL` (default `4` = INFO, exported by `shared.envs.sh`); it needs `8` (`LOG_LEVEL_DEBUG`). Everything from `info` up always prints. The value is read at call time, so raising it after sourcing works, and a non-numeric value falls back to INFO rather than aborting.

Color and style helpers are generated from the `COLORS`, `BG_COLORS`, and `STYLES` tables: `red`, `bright_cyan`, `bg_yellow`, `bold`, `dim`, `italic`, `underline`. Combined names like `bold_green` do not exist — nest instead, to any depth:

```bash
bold "$(green ok) rest"          # "ok" bold+green, " rest" still bold
```

Escapes are emitted only when **stderr** is a terminal (note the asymmetry: the text itself goes to stdout).

| Helper | Purpose |
|---|---|
| `fmt_badge <accent> <label>` | inline chip — Catppuccin accent text on `surface0` |
| `fmt_block <BG> [FG] <line>…` | multi-line colored rectangle; reads stdin if given no lines, and is the only helper that emits newlines |
| `indent [n]` | pipe filter, prefixes each line with `n` spaces (default 4) |
| `pad_left` / `pad_right <w> <s>` | align to `w` *display* columns, escape-aware |

Badges use the Catppuccin palette in 24-bit color, falling back to ANSI grounds when `COLORTERM` isn't `truecolor`. Switch flavors with `catppuccin_flavor macchiato` (or set `CATPPUCCIN_FLAVOR` before sourcing); `mocha` is the default.

`test/logger.sh` renders every color, style, badge, and flavor for eyeballing.

### Pattern: UI-Aware Top-Level Scripts

Top-level scripts own the notification layer. Child scripts write freely to stdout/stderr. The pattern:

```bash
#!/usr/bin/env bash

on_exit() {
  (( $? > 0 )) && notify-send "ERROR" "$msg" || notify-send "Done" "$msg"
}

set -euEo pipefail
trap on_exit EXIT

source "$MY_LIB_DIR/bash/logger.sh"
msg=""  # initialize before any failable command so trap is always safe
msg=$(some-child-script "$@" 2>&1)
```

## `bin/` Script Conventions

Scripts use `sys-get-os` to branch on platform (`arch`, `ubuntu`, `macos`, `fedora`, etc.). Cross-platform installs go through `sys-pkg-install` / `sys-pkg-check` / `sys-pkg-uninstall` rather than calling `apt`, `pacman`, or `brew` directly.

## Tmux

Reload config: `prefix + r` (displays a status message on success).

`tpm.sh` bootstraps TPM if not installed. Plugin list lives in `tmux.conf`.

## Ghostty

Machine-local overrides go in `~/.config/ghostty/local.ghostty` (gitignored). The auto-loaded theme is at `.config/ghostty/auto/theme.ghostty`, which includes `~/.config/my/theme/ghostty.conf` — the palette of whichever my-hyprland theme is currently applied. The include is optional (`?`), so this config still works without my-hyprland installed. To pin a fixed palette instead, replace that line with `theme = <name>` from `ghostty +list-themes`.
