return {
    {
        "catppuccin/nvim", 
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                transparent_background = true,
            })
            --vim.cmd.colorscheme "catppuccin"
        end,
    },
    {
        "ellisonleao/gruvbox.nvim", 
        priority = 1000, 
        config = function()
            require("gruvbox").setup({})
            --vim.cmd.colorscheme "gruvbox"
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night"
            })
            vim.cmd.colorscheme "tokyonight"
        end,
    }
}
