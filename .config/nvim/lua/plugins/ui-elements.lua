return {
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                window = {
                    winblend = 0 -- needed for catppucin 
                }
            }
        },
    },
    -- {
    --     "rcarriga/nvim-notify",
    --     config = function()
    --         require("notify").setup({
    --             stages = "fade_in_slide_out", -- Animation style
    --             timeout = 3000,              -- Time (in ms) before notification disappears
    --             background_colour = "#000000",
    --         })
    --
    --         -- Set `nvim-notify` as the default notification handler
    --         vim.notify = require("notify")
    --     end,
    -- },

    {
        -- Provides pretty GUI and allows for
        -- plugins to have the vim.ui.select
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({})
        end
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- add a border to hover docs and signature help
                },
            })
        end
    }
}
