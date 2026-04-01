# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration managed as part of a larger dotfiles repo. It uses **lazy.nvim** as the plugin manager with all plugin specs auto-imported from `lua/plugins/`.

## Architecture

```
init.lua → lua/config/init.lua
             ├── config/options.lua    (vim options, leader=space, filetype overrides)
             ├── config/keymaps.lua    (global keybindings)
             ├── config/lazy.lua       (lazy.nvim bootstrap + plugin loader)
             └── config/lsp_config.lua (shared LSP capabilities, diagnostics, LspAttach keymaps)

lua/plugins/       Plugin specs grouped by functionality (one file per concern)
lsp/               Individual LSP server configs (one file per language)
lua/custom/        Helper modules (Telescope pickers, lualine functions)
after/ftplugin/    Per-filetype overrides (indentation: lua/nix=2 spaces, c=4 spaces)
```

## Key Design Decisions

- **Native LSP** via `vim.lsp.config()` / `vim.lsp.enable()` — not mason or lspconfig plugin. Each server has its own file in `lsp/`.
- **Python dual-LSP**: basedpyright (types/hover/completion) + ruff (linting/formatting/import organization). Ruff has hover and completion disabled to avoid conflicts.
- **blink.cmp** for completion (not nvim-cmp). Capabilities are sourced from `blink.cmp` in `lsp_config.lua`.
- **conform.nvim** for formatting, **nvim-lint** for linting — not tied to LSP.
- **Delete operations use black hole register** by default (`d`, `dd`, `x`, `r` all mapped to `"_` register).
- **Catppuccin Macchiato** is the primary colorscheme with transparent background.

## Keymap Conventions

Leader key is `<Space>`. Keymaps follow a prefix pattern:
- `<leader>e` — edit actions (rename, format, code actions, docstrings)
- `<leader>j` — jump/navigation (definition, references, diagnostics, symbols)
- `<leader>s` — search (Telescope find files, grep, buffers)
- `<leader>g` — git (lazygit, browse, blame, hunks)
- `<leader>h` — harpoon file marks
- `<leader>d` — debug (DAP breakpoints, step, continue)
- `<leader>t` — toggles (tabs, spell check)
- `<leader>a` — AI assistant (codecompanion)

## Adding a New LSP Server

1. Create `lsp/<name>.lua` returning a config table with `cmd` and `filetypes`.
2. Add the server name to the `vim.lsp.enable()` list in `lua/config/lsp_config.lua`.

## Adding a New Plugin

Create or edit a file in `lua/plugins/`. Lazy.nvim auto-imports everything from that directory. Group plugins by functionality in existing files when appropriate.

## Formatting & Style

- Default indentation: 4 spaces (overridden per filetype in `after/ftplugin/`).
- Lua files in this config use tabs for indentation (stylua).
- Format-on-save is enabled via conform.nvim.
