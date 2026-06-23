```
 ███╗   ███╗██╗   ██╗     ███████╗██╗  ██╗███████╗██╗     ██╗     
 ████╗ ████║╚██╗ ██╔╝     ██╔════╝██║  ██║██╔════╝██║     ██║     
 ██╔████╔██║ ╚████╔╝█████╗███████╗███████║█████╗  ██║     ██║     
 ██║╚██╔╝██║  ╚██╔╝ ╚════╝╚════██║██╔══██║██╔══╝  ██║     ██║     
 ██║ ╚═╝ ██║   ██║        ███████║██║  ██║███████╗███████╗███████╗
 ╚═╝     ╚═╝   ╚═╝        ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
```

<div align="center">
  <img src="https://raw.githubusercontent.com/TylerDurham/my-shell/refs/heads/dev/media/terminal.png" width="200"/>
  <img src="https://raw.githubusercontent.com/TylerDurham/my-shell/refs/heads/dev/media/neovim.png" width="200"/>
 </div>

Personal dotfiles for Bash, Zsh, tmux, and Ghostty — designed to work across macOS, Arch Linux, Ubuntu, Fedora, and NixOS. Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink files into `$HOME` and a modular installer that can set up or revert everything in one command.

## Quick Start

```bash
git clone <repo-url> ~/Projects/my-shell
cd ~/Projects/my-shell
./setup            # install everything
./setup -r         # revert to backups
```

The `setup` script runs each module in `install.d/` in order: create directories, configure Bash, configure Zsh, then stow dotfiles.

## What's Included

### Shell Configuration

| File | Purpose |
|------|---------|
| `shared.envs.sh` | Environment variables shared across shells (paths, Homebrew, Go, NVM, Ollama, libvirt) |
| `shared.aliases.sh` | Cross-shell aliases (`lsd`, `bat`, `cls`) and package management helpers (`pi`, `pq`, `pr`) |
| `zsh.rc.sh` | Zsh entrypoint — loads envs, plugins, aliases, and shell integrations |
| `zsh.plugins.sh` | Zinit plugin manager with fast-syntax-highlighting, autosuggestions, fzf-tab, and completions |
| `bash.rc.sh` | Bash entrypoint |

### Tmux (`config/tmux/`)

| File | Purpose |
|------|---------|
| `tmux.conf` | Main config — vim-style navigation, popup support, mouse, inlined status bar theme |
| `popup.sh` | Helper for launching floating popup windows |
| `tpm.sh` | Bootstraps [TPM](https://github.com/tmux-plugins/tpm) if not installed |

### Ghostty (`config/ghostty/`)

| File | Purpose |
|------|---------|
| `config.ghostty` | Terminal config — padding, keybinds, SSH integration |
| `auto/theme.ghostty` | Ayu theme (auto-loaded) |
| `local.ghostty` | Optional machine-local overrides (gitignored) |

### Claude Code (`.claude/`)

Custom slash commands for [Claude Code](https://claude.ai/code):

| Command | Description |
|---------|-------------|
| `/cc` | Stage and create a Conventional Commit (with optional issue close) |
| `/commit` | Create a well-formed conventional commit from staged changes |
| `/file-header` | Add an ASCII banner + description header to a file |
| `/tag` | Create an annotated semantic version tag on HEAD |
| `/gh-issue` | Create a well-formed GitHub issue via `gh` |
| `/gh-pr-merge` | Open a PR from the current branch and squash-merge it |
| `/update-readme` | Sync the README to reflect the current state of the repo |

### CLI Utilities (`bin/`)

| Command | Description |
|---------|-------------|
| `sys-get-os` | Detect the current OS (macos, arch, ubuntu, fedora) |
| `sys-pkg-install` | Install packages with the right package manager for the current OS |
| `sys-pkg-check` | Check if a package is already installed |
| `sys-pkg-uninstall` | Remove packages cross-platform |
| `tmux-sessionizer` | Fuzzy-find a project directory and open it in a tmux session (inspired by ThePrimeagen) |
| `xtra-setup-sshd` | Configure sshd |

### Libraries (`lib/`)

| Library | Description |
|---------|-------------|
| `require.sh` | Module loader for Bash — sources scripts by name with dedup guards |
| `logger.sh` | Colored, leveled logging (debug/info/warn/error/fatal) with style helpers |

## Using `bin/` and `lib/` Scripts

### Sourcing the Libraries

Libraries live in `.local/share/my/lib/bash/`. Source them directly or use `require.sh` for dedup-safe loading:

```bash
PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Direct source
source "$PROJECT_ROOT/.local/share/my/lib/bash/logger.sh"

# Via require.sh (safe to call multiple times — loads each module at most once)
source "$PROJECT_ROOT/.local/share/my/lib/bash/require.sh" logger
```

`require.sh` resolves modules by name from `$MY_LIB_DIR/bash/`, or by explicit path if the argument starts with `/` or `./`.

### Logging

`logger.sh` provides leveled logging controlled by `LOG_LEVEL` (default: `1` = ERROR and above):

```bash
LOG_LEVEL=8  # enable all levels
export LOG_LEVEL

debug "low-level detail"   # level 8
info  "status message"     # level 4
warn  "something is off"   # level 2
error "something failed"   # level 1
fatal "unrecoverable"      # level 0 — also calls exit 1
```

Style helpers are available for ad-hoc output:

```bash
bold_green "Done!"
dim "skipping..."
red "uh oh"
```

Colors are auto-disabled when stdout is not a terminal (e.g. when output is captured or piped).

### Pattern: UI-Aware Top-Level Scripts

Child scripts (workers, installers, helpers) should write freely to stdout/stderr and exit with meaningful codes. Top-level scripts that interact with the desktop or a user-facing UI own the notification layer — they capture child output and handle it in an EXIT trap.

```bash
#!/usr/bin/env bash

on_exit() {
  if (( $? > 0 )); then
    notify-send "ERROR $(basename "$0")" "An error occurred:\n\n$msg"
    error "$msg"
  else
    notify-send "Success!" "$msg"
  fi
}

set -euEo pipefail

trap on_exit EXIT

PROJECT_ROOT=$(git rev-parse --show-toplevel)
source "$PROJECT_ROOT/.local/share/my/lib/bash/logger.sh"

msg=""  # initialize before any early exit so the trap is always safe

msg=$("$PROJECT_ROOT/.local/share/my/bin/some-child-script" "$@" 2>&1)
```

Key points:
- `set -euEo pipefail` — exit on any error, unset variable, or pipe failure
- `trap on_exit EXIT` — the handler always runs, success or failure
- `msg=""` — must be initialized before the first command that can fail; otherwise `set -u` will crash the trap if it fires early
- `2>&1` — merges stderr into stdout so the full child output (logs + errors) becomes the notification body

### `bin/` Scripts

The `bin/` scripts are standalone and callable from any script once `$MY_BIN_DIR` is on `$PATH` (set up by the shell config after install):

```bash
# Detect OS
os=$(sys-get-os)           # → "arch", "ubuntu", "macos", etc.

# Install packages (skips already-installed)
sys-pkg-install git curl ripgrep

# Check if a package is present
sys-pkg-check fzf && echo "fzf is installed"
```

## Shell Integrations

The Zsh config auto-detects and initializes these tools when available:

- [Starship](https://starship.rs/) — prompt
- [fzf](https://github.com/junegunn/fzf) — fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide) — smarter `cd`
- [mise](https://mise.jdx.dev/) — runtime/tool version manager
- [ngrok](https://ngrok.com/) — tunneling

## Project Layout

```
.
├── setup                       # Main installer entrypoint
├── install.d/                  # Installer modules
│   ├── envs.sh                 #   Shared vars and arg parsing
│   ├── mkdirs.sh               #   Create directory structure
│   ├── bash.sh                 #   Install .bashrc
│   ├── zsh.sh                  #   Install .zshrc
│   └── stow.sh                 #   Symlink dotfiles via GNU Stow
├── .claude/
│   ├── commands/               # Custom Claude Code slash commands
│   └── settings.json           # Claude Code project settings
├── .config/
│   ├── 1Password/ssh/          # 1Password SSH agent config
│   ├── ghostty/                # Ghostty terminal config and theme
│   └── tmux/                   # Tmux config, theme, and helper scripts
├── .local/share/my/
│   ├── bin/                    # CLI utilities (added to $PATH)
│   ├── lib/bash/               # Bash libraries
│   └── shell/                  # Shell rc/profile/alias/env files
└── .stow-local-ignore          # Files excluded from stow
```

## Requirements

- Bash 4+
- [GNU Stow](https://www.gnu.org/software/stow/)
- Zsh (optional, for Zsh config)
- tmux (optional, for tmux config)
- [Ghostty](https://ghostty.org/) (optional, for terminal config)
- [1Password](https://1password.com/) with SSH agent enabled (optional, for SSH key management)

## License

[MIT](LICENSE)
