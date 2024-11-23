local colorschemes = {
    {name = "catppuccin", spec = {
        "catppuccin/nvim",
        priority = 1000,
        lazy = false,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                transparent_background = true, -- disables setting the background color.
                flavour="macchiato",
                integrations = {
                    cmp = true,
                    diffview = true,
                    fidget = true,
                    gitsigns = true,
                    nvimtree = true,
                    harpoon = true,
                    notify = true,
                    markdown = true,
                    noice = true,
                    notifier = true,
                    dap = true,
                    dap_ui = true, 
                    treesitter_context = true,
                    treesitter = true,
                    render_markdown = true,
                    which_key = false,
                    telescope = {
                        enabled = true,
                    }
                }
            })
            vim.cmd.colorscheme("catppuccin")
        end
    }},

    {name = "tokyonight", spec = {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight")
        end
    }},

    {name = "gruvbox", spec = {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_palette = "mix"
            vim.cmd.colorscheme('gruvbox-material')
        end
    }},
}

local colorscheme = "catppuccin"
for _, opt in pairs(colorschemes) do
    if colorscheme == opt.name then
        return opt.spec
    end
end
vim.notify("Unable to find the colorscheme: \"" .. colorscheme .. "\"", vim.log.levels.ERROR)
return {}
