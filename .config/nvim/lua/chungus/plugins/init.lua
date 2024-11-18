-- List of plugins that do not require any configurations
return {
    {
        -- lua functions that many plugins use
        "nvim-lua/plenary.nvim", 
    },
    {
        -- Adds a notification tray for things 
        -- like the LSP
        "j-hui/fidget.nvim"
    },
    {
        -- Provides pretty GUI and allows for
        -- plugins to have the vim.ui.select
        "stevearc/dressing.nvim",
        opts = {},
    },
    {
        '0x00-ketsu/autosave.nvim',
        event = { "InsertLeave", "TextChanged" },
        config = function()
            require("autosave").setup({})
        end
    },
    {
        -- Open binaries in hex view
        "RaafatTurki/hex.nvim",
        config = function()
            require("hex").setup({})
        end,
    },
    {
        "Pocco81/true-zen.nvim",
        config = function()
            require("true-zen").setup({})
            vim.keymap.set("n", "<leader>z", ":TZFocus<CR>", {desc="Toggle pane maximization"})
        end
    },
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local undotree = require("undotree")
            undotree.setup({})
            vim.keymap.set("n", "<leader>u", undotree.toggle, {desc="undo tree"})
        end
    },
    {

        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end
    }
}
