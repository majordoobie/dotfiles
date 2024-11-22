-- List of plugins that do not require any configurations
return {
    {
        -- lua functions that many plugins use
        "nvim-lua/plenary.nvim", 
    },
    {
        '0x00-ketsu/autosave.nvim',
        config = function()
            local autosave = require("autosave")
            autosave.setup({
                prompt_style = "",
                event = { "InsertLeave", "TextChanged" },
            })

        end,
        -- Since we don't have any notifications, just tell the user that 
        -- the plugin is active when booting up
        init = function()
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    if vim.g.autosave_state then
                        vim.notify("💾 Autosave is active", vim.log.levels.INFO, { title = "Autosave Status" })
                    else
                        vim.notify("💾 Autosave is inactive", vim.log.levels.WARN, { title = "Autosave Status" })
                end
            end,
            })
        end,
    },
    {
        -- Open binaries in hex view
        "RaafatTurki/hex.nvim",
        config = function()
            require("hex").setup({})
        end,
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
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    }
}
