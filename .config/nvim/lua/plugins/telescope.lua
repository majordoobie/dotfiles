return {
    "nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",

        -- [[  Extensions ]]
		"nvim-telescope/telescope-ui-select.nvim",

        -- Allows passing args to ripgrep
		"nvim-telescope/telescope-live-grep-args.nvim",

        -- Makes searching faster
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		local lga_actions = require("telescope-live-grep-args.actions")

		telescope.setup({
			pickers = {
				current_buffer_fuzzy_find = {
					layout_strategy = "vertical",
				},
			},

			defaults = {
				path_display = { "absolute" },
				layout_strategy = "horizontal",
				layout_config = { horizontal = { height = 0.95, width = 0.95, preview_width = .75 }},
			},

			extensions = {
				live_grep_args = {
					auto_quoting = true,
					layout_strategy = "vertical",
				    layout_config = { height = 0.95, width = 0.95 },
					mappings = {
						i = {
							["C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            -- freeze the current list and start a fuzzy search in the frozen list
                            ["<C-space>"] = lga_actions.to_fuzzy_refine,
						},
					},
				},

				fzf = {
					case_mode = "smart_case",
				},

				["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
				},

			},
		})

		-- enable extensions
		telescope.load_extension("fzf") -- loads telescope-fzf-native.nvim
		telescope.load_extension("ui-select")
		telescope.load_extension("live_grep_args")

		local lga_shortcuts = require("telescope-live-grep-args.shortcuts")

		-- Searching with <leader>s
		vim.keymap.set("n", "<leader>sf", builtin.find_files,                                      { desc = "Search for files within the CWD" })
		vim.keymap.set("n", "<leader>sg", lga_shortcuts.grep_word_under_cursor,                    { desc = "Live grep for item udner cursor" })
		vim.keymap.set("v", "<leader>sg", lga_shortcuts.grep_visual_selection,                     { desc = "Live grep visual selection" })
		vim.keymap.set("n", "<C-f>", builtin.current_buffer_fuzzy_find,                            { desc = "ctrl + f" })
		vim.keymap.set("n", "<leader>sm", ":Telescope man_pages sections={'ALL'}<CR>",             { desc = "Search for man pages" })
		vim.keymap.set("n", "<leader>ss", builtin.spell_suggest,                                   { desc = "Check for the correct spelling under cursor" })
		vim.keymap.set("n", "<leader>sa", builtin.builtin,                                         { desc = "Display all Telescope options" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps,                                         { desc = "View all keymaps made" })

        -- Code searching with <leader>j
        vim.keymap.set("n", "<leader>js", function()
            builtin.lsp_document_symbols({ symbols = { "function", "method", "struct", "enum" } })
        end,                                                                                        { desc = "View symbols in the current file" })

        vim.keymap.set("n", "<leader>jS", builtin.lsp_document_symbols,                             { desc = "View ALL symbols in the current file" })
        vim.keymap.set("n", "<leader>jA", builtin.lsp_workspace_symbols,                            { desc = "View ALL symbols across project" })

		vim.keymap.set("n", "<leader>jr", builtin.lsp_references,                                   { desc = "View references of item under cursor" })
		vim.keymap.set("n", "<leader>ji", builtin.lsp_incoming_calls,                               { desc = "View what has called 'this' function" })
        vim.keymap.set("n", "<leader>jd", builtin.lsp_definitions,                                  { desc = "Jump to definition" })
        vim.keymap.set("n", "<leader>jD", builtin.lsp_implementations,                              { desc = "Jump to implementation" })

	end,
}
