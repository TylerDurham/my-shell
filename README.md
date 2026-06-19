```
 ███████╗██╗  ██╗███████╗██╗     ██╗     
 ██╔════╝██║  ██║██╔════╝██║     ██║     
 ███████╗███████║█████╗  ██║     ██║     
 ╚════██║██╔══██║██╔══╝  ██║     ██║     
 ███████║██║  ██║███████╗███████╗███████╗
 ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
```

Personal dotfiles for Bash and Zsh, designed to work across macOS, Arch Linux, Ubuntu, and Fedora. Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink files into `$HOME` and a modular installer that can set up or revert everything in one command.

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
├── .local/share/my/
│   ├── bin/                    # CLI utilities (added to $PATH)
│   ├── lib/bash/               # Bash libraries
│   └── shell/                  # Shell rc/profile/alias/env files
└── .stow-local-ignore          # Files excluded from stow
```

## Requirements

- Bash 4+
- [GNU Stow](https://www.gnu.org/software/stow/)
- Zsh (optional, for Zsh support)

## License

[MIT](LICENSE)
