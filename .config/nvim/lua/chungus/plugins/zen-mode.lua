return {
    -- Zooms a pane to full screen like a debugger window
    {
        "Pocco81/true-zen.nvim",
        config = function()
            require("true-zen").setup({})
            vim.keymap.set("n", "<leader>z", ":TZFocus<CR>", {desc="Toggle pane maximization"})
        end
    },

    -- centers the editor to the screen
    {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup({
                window = {
                    width = .60
                },
                plugins = {
                    options = {
                        -- you may turn on/off statusline in zen mode by setting 'laststatus' 
                        -- statusline will be shown only if 'laststatus' == 3
                        laststatus = 3, -- turn off the statusline in zen mode
                    }
                }
            })
            vim.keymap.set("n", "<leader>Z", ":ZenMode<CR>", {desc="Toggle zen mode"})

        end,
    }
}
