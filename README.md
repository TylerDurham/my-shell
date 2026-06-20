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
| `tmux.conf` | Main config — vim-style navigation, popup support, mouse, TPM bootstrap |
| `theme.conf` | Custom status bar theme |
| `os-icon.sh` | Detects current OS (including NixOS) and outputs the matching icon |
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
