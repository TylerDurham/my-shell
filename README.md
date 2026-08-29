```
 ███╗   ███╗██╗   ██╗     ███████╗██╗  ██╗███████╗██╗     ██╗     
 ████╗ ████║╚██╗ ██╔╝     ██╔════╝██║  ██║██╔════╝██║     ██║     
 ██╔████╔██║ ╚████╔╝█████╗███████╗███████║█████╗  ██║     ██║     
 ██║╚██╔╝██║  ╚██╔╝ ╚════╝╚════██║██╔══██║██╔══╝  ██║     ██║     
 ██║ ╚═╝ ██║   ██║        ███████║██║  ██║███████╗███████╗███████╗
 ╚═╝     ╚═╝   ╚═╝        ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
```

<div align="center">
  <img src="media/terminal.png" width="200"/>
  <img src="media/neovim.png" width="200"/>
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
| `auto/theme.ghostty` | Follows the active my-hyprland theme (auto-loaded) |
| `local.ghostty` | Optional machine-local overrides (gitignored) |

### Claude Code (`.claude/`)

Custom slash commands for [Claude Code](https://claude.ai/code):

| Command | Description |
|---------|-------------|
| `/cc` | Stage and create a Conventional Commit (with optional issue close) |
| `/commit` | Create a well-formed conventional commit from staged changes |
| `/encode` | Encode MakeMKV rips into movies or TV shows using HandBrake presets |
| `/file-header` | Add an ASCII banner + description header to a file |
| `/tag` | Create an annotated semantic version tag on HEAD |
| `/gh-issue` | Create a well-formed GitHub issue via `gh` |
| `/gh-pr-merge` | Open a PR from the current branch and squash-merge it |
| `/rip-disc` | Rip Blu-ray / 4K UHD discs with MakeMKV into `~/Rippy/@imports` |
| `/update-readme` | Sync the README to reflect the current state of the repo |

### CLI Utilities (`bin/`)

| Command | Description |
|---------|-------------|
| `ai-call-ollama` | Call a local or remote Ollama instance with a model, system prompt, and user prompt |
| `ai-git-commit-msg` | Generate a Conventional Commit message from staged diff using Ollama, then open it in `$EDITOR` |
| `backup-calibre.sh` | Archive and sync Calibre library from a remote host to local Dropbox backup |
| `sys-cache-thumbnail` | Generate and cache thumbnails for media files |
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
| `logger.sh` | Logging (debug/info/warn/error/fatal/success), ANSI color and style helpers, badges, and layout filters |

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

`logger.sh` provides a family of log helpers, all of which write to **stderr**:

```bash
info    "status message"      # [INFO] status message
warn    "something is off"    # [WARNING] something is off
error   "something failed"    # [ERROR] something failed
success "all done"            # [OK] all done          — alias: ok
debug   "low-level detail"    # [DEBUG] low-level detail
fatal 2 "unrecoverable"       # [FATAL] unrecoverable  — then exits 2
```

`fatal` takes the **exit status as its first argument**, and it is required — `fatal "msg"` will not do what you want.

Each helper has a `_badge` variant (`info_badge`, `error_badge`, …) that prefixes a colored chip instead of a bracketed label:

```bash
error_badge "disk full"       #  ▌ ERROR  disk full
```

Only `debug` is gated on `LOG_LEVEL`. Everything from `info` up always prints, on the grounds that a script that bothered to call `warn` wants it seen. `shared.envs.sh` exports `LOG_LEVEL=4` (INFO) and the `LOG_LEVEL_*` constants for every session, so turn debug output on per-invocation:

```bash
LOG_LEVEL=8 ./myscript        # or: LOG_LEVEL=$LOG_LEVEL_DEBUG ./myscript
```

### Colors, Styles, and Layout

Color and style helpers are generated from the `COLORS`, `BG_COLORS`, and `STYLES` tables, so the function name is just the lowercased table key. They write to stdout with **no trailing newline**, which keeps them composable — the caller owns the line breaks.

```bash
red "uh oh"; echo
dim "skipping..."; echo
bg_yellow "$(black " WARN ")"; echo

# No combined names like bold_green — nest instead, to any depth:
bold "$(green ok) rest"; echo    # "ok" bold+green, " rest" still bold
```

Available: `black` `red` `green` `yellow` `blue` `purple` `cyan` `white` plus their `bright_*` variants, the same set again as `bg_*` backgrounds, and the styles `bold` `dim` `italic` `underline`.

Higher-order formatters and layout filters:

```bash
fmt_badge red ERROR; echo " disk full"        # inline chip, accent on a muted ground
fmt_block RED "Deploy failed" "see the log"   # multi-line block of colored ground
printf '%s\n' one two | fmt_block BLUE        # ...or read the lines from stdin

{ green "ok"; echo; } | indent 2              # prefix each line with 2 spaces
pad_right 10 "$(blue "[INFO]")"               # align to 10 *display* columns
```

`pad_left`/`pad_right` measure what a string **looks like**, not what it weighs, so colored and accented text still lines up. `fmt_block` is the one helper that does emit newlines — a block is inherently line-oriented.

Badges are drawn from the [Catppuccin](https://catppuccin.com) palette in 24-bit color, falling back to plain ANSI grounds when `COLORTERM` isn't `truecolor`. `mocha` is the default flavor; switch with `catppuccin_flavor macchiato` after sourcing, or set `CATPPUCCIN_FLAVOR` before.

Escapes are emitted only when **stderr** is a terminal, so redirected output stays plain. Note the asymmetry: the check is on stderr while most helpers write to stdout, which means color survives a pipe (`red msg | indent 2`) but also survives `red msg > file`.

Run `test/logger.sh` to see every color, style, badge, and flavor rendered in your terminal.

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

### AI Tools (`ai-call-ollama`, `ai-git-commit-msg`)

These scripts talk to an [Ollama](https://ollama.com/) API endpoint. The target host is controlled by the `OLLAMA_HOST` environment variable, which defaults to `http://localhost:11434`.

`shared.envs.sh` sets `OLLAMA_HOST` to a remote instance. To override it for a session, or to point at a local Ollama instance instead:

```bash
export OLLAMA_HOST="http://localhost:11434"
```

To make the override permanent, add the export to `~/ollama.env.sh` (this file is sourced automatically by `shared.envs.sh` when it exists, and is gitignored):

```bash
echo 'export OLLAMA_HOST="http://localhost:11434"' >> ~/ollama.env.sh
```

#### `ai-call-ollama`

Send a prompt to any Ollama model and print the response:

```bash
# Basic usage
ai-call-ollama -m llama3.2 -s "You are a terse assistant." -p "What is a VLAN?"

# Pipe the user prompt from stdin
echo "Explain BGP in one sentence." | ai-call-ollama -m qwen2.5-coder:14b -s "Be concise."

# Stream the raw response as it generates
ai-call-ollama -m mistral -s "You are helpful." -p "Summarize TCP/IP." --stream
```

| Flag | Description |
|------|-------------|
| `-m`, `--model` | Model name (e.g. `llama3.1`, `qwen2.5-coder:14b`) |
| `-s`, `--system` | System prompt |
| `-p`, `--prompt` | User prompt (or pipe via stdin) |
| `--stream` | Stream raw JSON lines as the model generates |

Requires `curl` and `jq`.

#### `ai-git-commit-msg`

Generate a Conventional Commit message from the currently staged diff, open it in `$EDITOR` for review, then commit:

```bash
git add -p          # stage your changes
ai-git-commit-msg   # generate, edit, and commit
```

The script uses `qwen2.5-coder:14b` by default and respects `OLLAMA_HOST`.

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
