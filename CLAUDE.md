# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS-focused dotfiles repository managed with **Nix Darwin** and **GNU Stow**. It provides declarative system configuration for multiple macOS machines (nezuko and tanjiro) using Nix flakes.

## System Management Commands

### Initial Setup
```bash
# Clone and deploy dotfiles using stow
cd ~
git clone git@github.com:majordoobie/dotfiles.git
cd dotfiles
nix shell --extra-experimental-features 'nix-command flakes' nixpkgs#stow
stow .

# Initial nix-darwin installation (replace ${hostname} with nezuko or tanjiro)
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix#${hostname}
```

### Rebuilding System Configuration
```bash
# Basic rebuild (after first installation)
darwin-rebuild switch --flake ~/dotfiles/nix#${hostname}

# Rebuild with updates using nh (recommended)
nh darwin switch ~/dotfiles/nix/ --hostname nezuko --update
nh darwin switch ~/dotfiles/nix/ --hostname tanjiro --update
```

### Stow Management
When adding or updating dotfiles in `.config/`, use stow to symlink them:
```bash
# From ~/dotfiles directory
stow .  # Creates symlinks for all non-ignored files
```

Files/directories excluded from stowing are defined in `.stow-local-ignore`.

## Architecture

### Nix Configuration Structure

```
nix/
├── flake.nix                    # Main flake entry point
├── darwin/
│   ├── default.nix              # Defines nezuko and tanjiro system configs
│   ├── darwin-defaults-config.nix  # Shared macOS system settings
│   └── darwin-default-apps.nix  # Base packages and homebrew apps
├── hosts/
│   ├── nezuko/default.nix       # M4 Pro MacBook (dev machine)
│   └── tanjiro/default.nix      # M2 Mac Mini (server/headless)
└── modules/
    ├── fish.nix                 # Fish shell configuration
    ├── touchID.nix              # TouchID for sudo in tmux
    ├── aerospaceConfig.nix      # Window manager config
    └── development_config/      # Language-specific tooling
        ├── python.nix
        ├── c.nix
        ├── docker.nix
        ├── lua.nix
        ├── nix.nix
        ├── shell.nix
        ├── web.nix
        └── yaml.nix
```

### Multi-Host Configuration

- **nezuko** (M4 Pro MacBook): Primary development machine with full GUI apps, development tools, and Homebrew casks
- **tanjiro** (M2 Mac Mini): Headless server with SSH enabled, minimal GUI apps, runs Plex

Both machines:
- Share base configuration from `darwin-defaults-config.nix` and `darwin-default-apps.nix`
- Use Fish shell configured via `modules/fish.nix`
- Have experimental Nix features enabled (flakes, nix-command)
- Auto-import development language modules as needed

### Key Design Patterns

1. **Layered Configuration**: Base system defaults → host-specific overrides
2. **Modular Development Environments**: Each language has its own module with LSP, formatters, and linters
3. **Fish Overlay**: Custom overlay in `darwin/default.nix` disables Fish tests (`doCheck = false`) to speed up builds
4. **Trusted Users**: Nix daemon allows @admin users without sudo
5. **Package Tracking**: List of installed packages written to `/etc/installed-packages` for reference

### Application Management

- **Nix packages**: CLI tools, development tools, LSPs (in `environment.systemPackages`)
- **Homebrew casks**: GUI applications (defined in `homebrew.casks`)
- **Homebrew brews**: Tools not available or problematic in Nix (sketchybar, switchaudio-osx, opencode)

### Fish Shell Configuration

Shell is configured declaratively in `nix/modules/fish.nix` with:
- Custom functions: `cd` (aliased to zoxide), `ls` (aliased to eza), `tree`, `mk`, `cp`, `cf`
- Vi mode keybindings via `fish_vi_key_bindings`
- Starship prompt, fzf, zoxide integration
- Catppuccin Mocha theme
- 1Password SSH agent integration

### Dotfile Locations

Application configs are in `.config/`:
- `nvim/` - Neovim configuration (Lua-based)
- `fish/` - Fish shell runtime config (complementary to Nix declaration)
- `tmux/` - Tmux configuration
- `ghostty/` - Ghostty terminal config
- `lazygit/`, `btop/`, `git/`, etc. - Other TUI tools

## Development Tooling

### Language-Specific LSPs and Tools

Each development environment module provides a complete toolchain:

- **Python**: python3, uv, basedpyright (LSP), ruff (linter + formatter)
- **C/C++**: clang-tools, cmake, cmake-language-server, cmake-format, cmake-lint
- **Lua**: lua-language-server, stylua (formatter), luacheck (linter)
- **Nix**: nil (LSP), nixfmt-rfc-style (formatter)
- **Shell**: bash-language-server, shellcheck (linter), shfmt (formatter)
- **Web**: vscode-langservers-extracted (JSON/HTML LSPs), prettierd, cjson
- **YAML**: yaml-language-server, yamlfmt
- **Docker**: docker, docker-compose-language-service, OrbStack (GUI via Homebrew)

### TouchID for sudo in tmux

The `touchID.nix` module enables TouchID authentication for sudo within tmux sessions using `pam-reattach`.

## System Customization

Key macOS system preferences (in `darwin-defaults-config.nix`):
- Timezone: America/New_York
- Dark mode enabled
- Key repeat: 2, Initial key repeat: 15 (very fast)
- Caps Lock remapped to Control
- Finder: show all files, extensions, path bar; hide desktop icons
- Dock: auto-hide with 0 delay
- Desktop wallpaper: `~/dotfiles/images/cute_cat.png`
- Screenshots saved to `~/Downloads/Screenshots`
- Disable .DS_Store on network/USB volumes

## Garbage Collection

Nix automatically runs garbage collection:
- **Schedule**: Every Sunday at 2:00 AM
- **Policy**: Delete generations older than 30 days
- **Command**: `--delete-older-than 30d`
