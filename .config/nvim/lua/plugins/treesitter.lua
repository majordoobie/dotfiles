return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",

        config = function()
            local treesitter = require("nvim-treesitter.configs")

            treesitter.setup({
                highlight = {enable = true},
                indent = {enable = true},
                ensure_installed = {
                    "arduino",
                    "asm",
                    "bash",
                    "c",
                    "cpp",
                    "cmake",
                    "diff",
                    "disassembly",
                    "dockerfile",
                    "doxygen",
                    "git_config",
                    "git_rebase",
                    "go",
                    "html",
                    "java",
                    "javascript",
                    "json",
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
                    "vim",
                    "vimdoc",
                    "toml",
                    "yaml",
                    "zig",
                },
            })

        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("treesitter-context").setup()
        end
    }
}
