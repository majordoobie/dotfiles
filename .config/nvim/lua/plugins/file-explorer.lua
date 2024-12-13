return {
    {
        'Bekaboo/dropbar.nvim',
        -- optional, but required for fuzzy finder support
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        }
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 30
                },
                actions = {
                    open_file = {
                        quit_on_open = false,
                    },
                },
            })

            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1


            vim.keymap.set("n", "gf", ":NvimTreeToggle<CR>", { desc = "Open up the tree" })
        end
    },
    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,

                columns = {
                    "icon",
                    "size",
                },

                view_options = {
                    show_hidden = true,
                    natural_order = true,
                    is_hidden_file = function(name, _)
                        return name == ".." or name == ".git"
                    end
                },

                win_options = {
                    wrap = false,
                    signcolumn = "no",
                    cursorcolumn = false,
                    foldcolumn = "0",
                    spell = false,
                    list = true,
                    conceallevel = 3,
                    concealcursor = "nvic",
                },
            })

            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end
    }
}
