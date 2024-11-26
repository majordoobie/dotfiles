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
}
