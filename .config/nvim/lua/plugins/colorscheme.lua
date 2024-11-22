function set_oxocarbon()
    return {
        "nyoom-engineering/oxocarbon.nvim",
        priority = 1000,
        lazy = false,

        config = function()
            vim.cmd("colorscheme oxocarbon")
        end
    }
end

function set_evangelion()
    return {
        "xero/evangelion.nvim",
        priority = 1000,
        lazy = false,

        config = function()
            vim.cmd("colorscheme evangelion")
        end
    }
end

function set_catppuccin()
    return {
        "catppuccin/nvim",
        priority = 1000,
        lazy = false,

        config = function()
            require("catppuccin").setup({
                transparent_background = true,
                flavour="macchiato"
            })

            vim.cmd("colorscheme catppuccin")
        end
    }
end

function set_gruvbox()
    return {
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
    }
end

function set_tokyonight()
    return {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
            --vim.cmd.colorscheme("tokyonight-moon")
        end
    }
end

return {
    set_catppuccin()
    --set_evangelion()
    --set_oxocarbon()
    --set_gruvbox()
    --set_tokyonight()
}
