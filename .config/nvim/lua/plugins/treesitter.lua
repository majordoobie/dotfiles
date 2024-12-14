return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",

        config = function()
            local treesitter = require("nvim-treesitter.configs")

            treesitter.setup({
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = {
                    "arduino",
                    "asm",
                    "bash",
                    "c",
                    "cpp",
                    "cmake",
                    "csv",
                    "diff",
                    "disassembly",
                    "dockerfile",
                    "doxygen",
                    "git_config",
                    "git_rebase",
                    "gitignore",
                    "go",
                    "html",
                    "htmldjango",
                    "http",
                    "hjson",
                    "java",
                    "javascript",
                    "json",
                    "json5",
                    "jsonc",
                    "latex",
                    "llvm",
                    "lua",
                    "luap",
                    "make",
                    "objdump",
                    "python",
                    "requirements",
                    "regex",
                    "rust",
                    "sql",
                    "strace",
                    "tmux",
                    "nix",
                    "vim",
                    "vimdoc",
                    "toml",
                    "yaml",
                    "zig",
                },
            })
        end
    },
    -- {
    --     "nvim-treesitter/nvim-treesitter-context",
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     config = function()
    --         require("treesitter-context").setup()
    --     end
    -- }
}
