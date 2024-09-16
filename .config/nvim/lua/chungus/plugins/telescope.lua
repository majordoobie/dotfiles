return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",

        -- extensions
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-frecency.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        --"nvim-telescope/telescope-media-files",
        {"nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        local actions = require("telescope.actions")
        local lga_actions = require("telescope-live-grep-args.actions")
        local telescope = require("telescope")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                  i = {
                    ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                    ["<C-j>"] = actions.move_selection_next, -- move to next result
                    ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                  },
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },

                ["live_grep_args"] = {
                    auto_quoting=true,
                    mappings = {
                        i = {
                            ["C-k>"] = lga_actions.quote_prompt(),
                        },
                    },
                },
            },
        })
        
		---- enable extentions
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("live_grep_args")
        telescope.load_extension("file_browser")

		---- remaps
        local builtin = require("telescope.builtin")
        local telescope = require("telescope")
        local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

        -- searc for files
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>sF', function() builtin.find_files { cwd = "~", hidden=true, glob_pattern="!.git/"} end)

        -- grep text in files
        vim.keymap.set("n", "<leader>sg", telescope.extensions.live_grep_args.live_grep_args, {desc = "Live grep with `rg` cmds"})
        vim.keymap.set("v", "<leader>sg", live_grep_args_shortcuts.grep_visual_selection, {desc="Search for the highlighted word"}) 

        -- search man pages
        vim.keymap.set("n", "<leader>sm", ":Telescope man_pages sections={'ALL'}<CR>")

        vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })

    end
}
