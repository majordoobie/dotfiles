return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",

		-- extensions
		"nvim-telescope/telescope-live-grep-args.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local lga_actions = require("telescope-live-grep-args.actions")
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

		telescope.setup({
			pickers = {
				find_files = {
					layout_config = { preview_width = 0.70 },
				},
			},
			defaults = {
				path_display = { "absolute" },
                -- layout_strategy = "vertical",
                layout_config = { height = 0.95, width = 0.95 },
			},
			extensions = {
				fzf = {
					case_mode = "smart_case",
				},

				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},

				["live_grep_args"] = {
					auto_quoting = true,
                    layout_strategy = "vertical",
					mappings = {
						i = {
							["C-k>"] = lga_actions.quote_prompt(),
						},
					},
				},
			},
		})

		-- enable extensions
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("live_grep_args")

		-- search for files
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sF", function()
			builtin.find_files({ cwd = "~", hidden = true, glob_pattern = "!.git/" })
		end)
		vim.keymap.set("n", "<leader>sc", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end)

		-- grep text in files
		vim.keymap.set(
			"n",
			"<leader>sg",
			telescope.extensions.live_grep_args.live_grep_args,
			{ desc = "Live grep with `rg` cmds" }
		)

		vim.keymap.set(
			"v",
			"<leader>sg",
			live_grep_args_shortcuts.grep_visual_selection,
			{ desc = "Search for the highlighted word" }
		)
		vim.keymap.set("n", "<C-f>", builtin.current_buffer_fuzzy_find, { desc = "ctrl + f" })

		-- search man pages
		vim.keymap.set("n", "<leader>sm", ":Telescope man_pages sections={'ALL'}<CR>")
        vim.keymap.set("n", "<leader>ss", builtin.spell_suggest, { desc = "Spell Suggestion" })
		vim.keymap.set("n", "<leader>sa", builtin.builtin, { desc = "Telescope ALL" })
	end,
}
