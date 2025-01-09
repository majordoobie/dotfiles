return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            extensions = {
                "oil",
                "toggleterm",
                "fzf",
                "man",
                "nvim-dap-ui",

            },
            options = {
                theme = "catppuccin",
            },
            sections = {
                lualine_a = {'mode', 'searchcount'},
                lualine_b = {'branch', 'diff'},
                lualine_c = {'diagnostics', 'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'filesize'},
                lualine_z = {'progress', 'location'}
            },
        })
    end,
}
