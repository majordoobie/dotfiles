-- harpoon like app
return {
    {
        "fnune/recall.nvim",
        
        config = function()
            local recall = require("recall")
            recall.setup({})

            vim.keymap.set("n", "<leader>ms", recall.toggle, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>ml", recall.goto_next, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>mh", recall.goto_prev, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>mc", recall.clear, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>mm", ":Telescope recall<CR>", { noremap = true, silent = true })

            vim.keymap.set("n", "<leader>m1", "`A");
            vim.keymap.set("n", "<leader>m2", "`B");
            vim.keymap.set("n", "<leader>m3", "`C");
            vim.keymap.set("n", "<leader>m4", "`D");
            vim.keymap.set("n", "<leader>m5", "`E");
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim"},
        config = function()
            local harpoon = require('harpoon')
            harpoon:setup({})

            -- basic telescope configuration
            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<leader>hv", function() toggle_telescope(harpoon:list()) end)

            vim.keymap.set("n", "h1", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "h2", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "h3", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "h4", function() harpoon:list():select(4) end)
            vim.keymap.set("n", "h5", function() harpoon:list():select(5) end)
            vim.keymap.set("n", "h6", function() harpoon:list():select(6) end)
            vim.keymap.set("n", "h7", function() harpoon:list():select(7) end)
            vim.keymap.set("n", "h8", function() harpoon:list():select(8) end)
            vim.keymap.set("n", "h9", function() harpoon:list():select(9) end)
            vim.keymap.set("n", "h0", function() harpoon:list():select(0) end)
        end
    }
}

