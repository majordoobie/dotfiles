# Neovim Configuration Architecture

## Overview

This is a modern, modular Neovim configuration built around **Lazy.nvim** as the plugin manager. The setup provides an IDE-like experience with comprehensive LSP integration, Git workflows, and keyboard-driven navigation optimized for multi-language development.

## Directory Structure

```
.config/nvim/
├── init.lua                 # Entry point (requires "config")
├── lazy-lock.json           # Plugin version lockfile
├── lua/
│   ├── config/              # Core configuration
│   │   ├── init.lua         # Loads all config modules
│   │   ├── options.lua      # Vim options & settings
│   │   ├── keymaps.lua      # Global keymaps
│   │   ├── lazy.lua         # Plugin manager bootstrap
│   │   └── lsp_config.lua   # LSP global configuration
│   ├── plugins/             # Plugin specifications (lazy-loaded)
│   └── custom/              # Custom helper functions
├── lsp/                     # Individual LSP server configs
└── after/ftplugin/          # Filetype-specific settings
```

## Bootstrap Flow

1. **init.lua** → Requires `config` module
2. **lua/config/init.lua** → Loads in order:
   - `options.lua` - Vim settings
   - `keymaps.lua` - Global keybindings
   - `lazy.lua` - Plugin manager setup
   - `lsp_config.lua` - LSP configuration
3. **Lazy.nvim** auto-imports all modules in `lua/plugins/`

## Plugin Management: Lazy.nvim

- **Auto-bootstrap**: Clones lazy.nvim if not installed
- **Auto-loading**: All files in `lua/plugins/` are automatically imported
- **Features**:
  - Auto-update checker (silent notifications)
  - Change detection disabled
  - Lazy loading on events (`VeryLazy`, `BufEnter`, etc.)

## LSP Architecture

### Global Configuration (`lua/config/lsp_config.lua`)

- Uses `blink.cmp` for completion capabilities
- Position encoding: UTF-16/UTF-8
- Inlay hints enabled globally
- Custom diagnostic signs: ` ` ` ` `󰠠` ` `
- Virtual text only on current line

### Individual Server Configs (`lsp/` directory)

Each LSP server has its own config file returning a table:
- **Python**: basedpyright
- **Lua**: lua-language-server
- **C/C++**: clangd
- **Shell**: bash-language-server
- **Nix**: nil
- **Web**: JSON, YAML, TOML

Servers enabled via `vim.lsp.enable()` array.

### LSP Keybindings

Leader-based organization (`<Space>` as leader):

**Jump/Navigation (`<leader>j*`)**:
- `<leader>jd` - Go to definition
- `<leader>jr` - Find references
- `<leader>jE` - Show diagnostics

**Edit/Actions (`<leader>e*`)**:
- `<leader>er` - Rename symbol
- `<leader>ee` - Code actions
- `<leader>ef` - Format buffer

**Diagnostics**:
- `K` - Hover documentation
- `D` - Toggle virtual lines
- `[d` / `]d` - Navigate diagnostics

## Key Plugin Categories

### IDE Features

- **Completion**: `blink.cmp` - Fast, compiled completion engine
- **Formatting**: `conform.nvim` - Supports Lua, Python, C, Nix, JSON, YAML
- **Linting**: `nvim-lint`
- **Treesitter**: Syntax highlighting for 30+ languages
- **DAP**: Debugging for Python & C/C++ with `nvim-dap`

### Navigation & Search

- **Telescope**: Fuzzy finder with extensions:
  - `live-grep-args` - Advanced text search
  - `undo` - Undo tree visualization
  - Dynamic layouts based on screen width
- **Harpoon**: Quick file bookmarks (1-9 access)
- **Recall**: Advanced mark system
- **Oil.nvim**: File explorer as editable buffer

### Git Integration

- **CodeDiff**: Advanced diff viewer with explorer panel
- **Gitsigns**: Inline git changes, hunk navigation
- **Blame.nvim**: Git blame annotations
- **Snacks.lazygit**: LazyGit integration

### UI Enhancements

- **Lualine**: Status line with LSP info, git branch, venv
- **Noice.nvim**: Enhanced command/message UI
- **Dropbar**: Breadcrumb navigation
- **Treesitter-context**: Shows current function/class at top
- **Which-key**: Keymap help popup
- **Catppuccin**: Colorscheme (macchiato flavor, transparent)

### Text Editing

- **Mini.nvim**: Text editing utilities
- **Nvim-autopairs**: Auto-close brackets/quotes
- **Neogen**: Docstring generation (reST for Python)
- **Autosave**: Optional auto-save toggle

### Utilities

- **Snacks.nvim**: Multi-purpose utilities:
  - Terminal integration
  - Zen mode
  - Dashboard
  - Indent guides
- **Venv-selector**: Python virtual environment picker
- **Hex.nvim**: Binary file viewer
- **Vim-tmux-navigator**: Seamless tmux/vim navigation

## Keymap Organization

### Leader Key Philosophy

Space (`<Space>`) as leader with organized prefixes:

- `<leader>s*` - **Search**: sf=files, sg=grep, sk=keymaps, su=undo
- `<leader>j*` - **Jump**: LSP navigation (definition, references, diagnostics)
- `<leader>e*` - **Edit**: LSP actions (rename, code actions, format)
- `<leader>g*` - **Git**: gb=blame, gd=diff, gs=stage hunk
- `<leader>h*` - **Harpoon**: File bookmarks (ha=add, hm=menu, h1-h9=jump)
- `<leader>m*` - **Marks**: Recall mark system
- `<leader>t*` - **Toggle**: Settings (tc=conceal, tp=spell, ta=autosave)
- `<leader>d*` - **Debug**: DAP operations (db=breakpoint, dc=continue)
- `<leader>n*` - **Noice**: Notifications (nd=dismiss, nh=history)

### Smart Clipboard Handling

- Delete operations use black hole register (`"_d`, `"_dd`, `"_x`)
- `<leader>y` / `<leader>p` - System clipboard operations
- Visual paste doesn't yank deleted text

## Custom Features

1. **Robot Framework Support**: Custom syntax for `.robot` files
2. **Dynamic Telescope Layouts**: Auto-switches vertical/horizontal based on screen width
3. **Inlay Hints**: Enabled globally for all LSP servers
4. **Spell Check Toggle**: `<leader>tp` with notification
5. **Remote Debugging**: Configured for C/C++ with lldb-server
6. **Yank Highlighting**: Visual feedback on yank operations
7. **Dashboard**: Custom startup screen with git status

## Development Environment Support

| Language | LSP | Formatter | Linter | Debugger |
|----------|-----|-----------|--------|----------|
| Python | basedpyright | ruff | ruff | debugpy |
| C/C++ | clangd | clang-format | - | codelldb |
| Lua | lua-ls | stylua | - | - |
| Nix | nil | nixpkgs-fmt | - | - |
| Shell | bash-ls | shfmt | - | - |
| Web | json/yaml-ls | prettier | - | - |

## Filetype-Specific Settings

Located in `after/ftplugin/`:
- **C**: 4-space tabs
- **Lua**: 2-space tabs
- **Nix**: 2-space tabs
- **Docker Compose**: Custom filetype detection for `.compose.yaml`

## Performance Optimizations

- Lazy loading for most plugins (`event = "VeryLazy"`)
- Bigfile detection disables LSP on large files
- LSP log level set to WARN
- Change detection notifications disabled
- Treesitter incremental parsing
- Virtual text only on current line (reduces UI clutter)

## Custom Functions

Located in `lua/custom/`:

- **lualine_functions.lua**: 
  - LSP client names display
  - Virtual environment display
  - Git branch truncation
  
- **custom_pickers.lua**: 
  - Custom Telescope pickers
  - Dynamic layout logic

## Configuration Philosophy

This configuration emphasizes:

1. **Modularity**: Clear separation of concerns with dedicated directories
2. **Performance**: Lazy loading and optimizations for smooth editing
3. **Discoverability**: Which-key for keymap help, organized leader prefixes
4. **IDE Experience**: Full LSP integration with formatting, linting, and debugging
5. **Git-centric Workflow**: Multiple Git tools for different use cases
6. **Keyboard-driven**: Minimal mouse dependency with efficient keybindings

## Extending the Configuration

### Adding a New Plugin

Create a file in `lua/plugins/`:

```lua
return {
  "author/plugin-name",
  event = "VeryLazy",
  config = function()
    require("plugin-name").setup({
      -- configuration
    })
  end,
}
```

### Adding a New LSP Server

1. Create `lsp/servername.lua`:
```lua
return {
  settings = {
    -- server-specific settings
  }
}
```

2. Add to `vim.lsp.enable()` array in `lua/config/lsp_config.lua`

### Adding Keymaps

Add to `lua/config/keymaps.lua` following the leader prefix convention.
