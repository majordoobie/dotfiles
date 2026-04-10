# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim 0.12 configuration managed as part of a larger dotfiles repo. All plugins are managed with the built-in **vim.pack** plugin manager (lazy.nvim has been fully removed).

## Architecture

```
init.lua → lua/config/init.lua
             ├── config/options.lua      (vim options, leader=space, filetype overrides)
             ├── config/keymaps.lua      (global keybindings)
             ├── config/pack_config.lua  (git_source() global, plugin management keymaps)
             ├── config/lsp_config.lua   (shared LSP capabilities, diagnostics, LspAttach keymaps)
             │
             ├── packs/common.lua             (plenary, hex.nvim, vim-tmux-navigator)
             ├── packs/treesitter.lua         (nvim-treesitter parser installation)
             ├── packs/file_tree.lua          (oil.nvim, nvim-web-devicons)
             ├── packs/telescope.lua          (telescope + extensions: fzf-native, live-grep-args)
             ├── packs/snacks_plug.lua        (snacks.nvim: dashboard, zen, terminal, indent, images)
             ├── packs/ui_elements.lua        (catppuccin, noice, lualine, dropbar, which-key, treesitter-context, stay-centered)
             ├── packs/harpoon.lua            (harpoon, recall.nvim)
             ├── packs/mini_text_edit.lua     (mini.nvim: comment, move, surround, visits, cursorword, hipatterns)
             ├── packs/ide_editing.lua        (neogen, autosave, autopairs, venv-selector)
             ├── packs/codediff.lua           (codediff.nvim with binary bootstrap)
             ├── packs/git_integrations.lua   (gitsigns, blame)
             ├── packs/markdown.lua           (render-markdown.nvim)
             ├── packs/ide_completion.lua     (blink.cmp with binary bootstrap, lazydev, friendly-snippets)
             ├── packs/ide_formatter.lua      (conform.nvim)
             ├── packs/ide_linter.lua         (nvim-lint)
             ├── packs/nvim_dap.lua           (nvim-dap, dap-ui, dap-virtual-text)
             ├── packs/ai_slop.lua            (codecompanion.nvim)
             └── packs/nvim_builtin_plugins.lua (undotree, nohlsearch, tohtml)

lsp/               Individual LSP server configs (one file per language)
lua/custom/        Helper modules (Telescope pickers, lualine functions)
after/ftplugin/    Per-filetype overrides (indentation: lua/nix=2 spaces, c=4 spaces)
```

## Plugin Management (vim.pack)

- Plugins are managed with Neovim 0.12's built-in `vim.pack`.
- `_G.git_source()` is defined in `config/pack_config.lua` as a global shorthand for GitHub URLs.
- Each pack file follows this structure:
  1. **Top**: `vim.pack.add()` declarations (and `PackChanged` hooks if needed)
  2. **Middle**: Plugin configurations separated by doc comment headers
  3. **Bottom**: All keybindings
- Most plugins use `load = true` in `vim.pack.add()` since configs/keymaps need the plugin available immediately during init.lua.
- Build steps (like `make` for telescope-fzf-native, `cargo build` for blink.cmp) use `PackChanged` autocmd hooks.
- Plugin management keymaps: `<leader>pl` (list), `<leader>pu` (update), `<leader>pd` (delete orphans).
- Lockfile: `nvim-pack-lock.json` in the config root.
- Plugins are stored on disk at `~/.local/share/nvim/site/pack/core/opt/`.
- Built-in optional plugins (undotree, nohlsearch, tohtml) use `vim.cmd.packadd()` — not vim.pack.

## Plugins with Native Binaries

Some plugins require compiled binaries. The config handles this with a fallback chain:

### blink.cmp (fuzzy matcher)
1. Check if binary exists (`target/release/*.dylib` or `*.so`)
2. Try fileshare: `/mnt/software/Neovim/blink.cmp/blink.cmp_<version>.so`
3. Build from source: `cargo build --release`
4. Fallback: Lua fuzzy implementation (`fuzzy.implementation = "lua"`)

### codediff.nvim (diff engine)
1. Check if binary exists (`libvscode_diff_*` in plugin root)
2. Try fileshare: `/mnt/software/Neovim/codediff.nvim/codediff.nvim-libvscode_<version>.so`
3. Fallback: prompt user to run `:CodeDiff install`

## Air-Gapped Network Support

This config is deployed on both internet-connected (macOS) and air-gapped (Linux/WSL) machines.

- Prebuilt binaries for blink.cmp and codediff are synced to the fileshare at `/mnt/software/Neovim/` using the **git-sync** tool at `/Users/nezuko/code/active_projects/gitlab_repo_update`.
- **gsync** (`/Users/nezuko/code/active_projects/gsync`) installs binaries from git-sync output onto the air-gapped system (copies to `/opt/`, symlinks to `/usr/local/bin/`, places shared libs on fileshare).
- git-sync downloads GitHub release binaries, npm packages, neovim plugins (as git mirrors), and tree-sitter parsers for offline use.
- On the air-gapped network, the fileshare is mounted at `/mnt/software/` (WSL: `mount -t drvfs '\\fileshare' /mnt/software`).

## Adding a New Plugin

1. Add `git_source("user/repo")` to the `vim.pack.add()` call in the appropriate `lua/packs/*.lua` file.
2. Add configuration below in the configs section, keymaps in the keybindings section.
3. If the plugin needs a build step, add a `PackChanged` autocmd before the `vim.pack.add()` call.
4. If the plugin has a native binary for air-gapped use, add fileshare lookup logic (see blink.cmp/codediff patterns) and add the binary to the git-sync BINARIES list.

## Key Design Decisions

- **Native LSP** via `vim.lsp.config()` / `vim.lsp.enable()` — not mason or lspconfig plugin. Each server has its own file in `lsp/`.
- **Python LSP**: ty (type checking, from Astral/Ruff team) + ruff (linting/formatting/import organization). basedpyright available but disabled. Ruff has hover and completion disabled to avoid conflicts.
- **blink.cmp** for completion (not nvim-cmp). Capabilities are sourced from `blink.cmp` in `lsp_config.lua`.
- **conform.nvim** for formatting, **nvim-lint** for linting — not tied to LSP.
- **Delete (`d`/`dd`/`D`)** uses default behavior (yank + delete) for cut/paste. `x` and `r` use black hole register. Visual paste (`p`) keeps clipboard.
- **Catppuccin Macchiato** is the primary colorscheme with transparent background.
- **nvim-treesitter** on 0.12 only manages parser installation — highlight/indent are native.

## Keymap Conventions

Leader key is `<Space>`. Keymaps follow a prefix pattern:
- `<leader>e` — edit actions (rename, format, code actions, docstrings)
- `<leader>j` — jump/navigation (definition, references, diagnostics, symbols)
- `<leader>s` — search (Telescope find files, grep, buffers)
- `<leader>g` — git (lazygit, codediff, browse, blame, hunks)
- `<leader>h` — harpoon file marks
- `<leader>m` — recall marks
- `<leader>d` — debug (DAP breakpoints, step, continue)
- `<leader>n` — noice notifications
- `<leader>p` — plugin management (list, update, delete orphans)
- `<leader>t` — toggles (tabs, spell check, autosave)
- `<leader>u` — undo tree (built-in)
- `<leader>a` — AI assistant (codecompanion)

## Adding a New LSP Server

1. Create `lsp/<name>.lua` returning a config table with `cmd` and `filetypes`.
2. Add the server name to the `vim.lsp.enable()` list in `lua/config/lsp_config.lua`.

## Formatting & Style

- Default indentation: 4 spaces (overridden per filetype in `after/ftplugin/`).
- Lua files in this config use tabs for indentation (stylua).
- Format-on-save is enabled via conform.nvim.
- Lualine separators and dashboard icons use Nerd Font / Powerline glyphs — do not strip these special Unicode characters when editing.
- Preserve all existing comments, emojis in keymap descriptions, and doc headers when modifying files.
