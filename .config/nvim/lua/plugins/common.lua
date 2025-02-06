-- List of plugins that do not require any configurations
return {
    {
        -- lua functions that many plugins use
        "nvim-lua/plenary.nvim",
        lazy = true
    },
    {
        -- Open binaries in hex view
        "RaafatTurki/hex.nvim",
        config = function()
            require("hex").setup({})
        end,
    },
    {

        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end
    },
    {
        "christoomey/vim-tmux-navigator",
        event="VeryLazy",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    }
}
