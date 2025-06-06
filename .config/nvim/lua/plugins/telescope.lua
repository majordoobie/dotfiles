return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",

		-- [[  Extensions ]]
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

			defaults = {
				path_display = { "absolute" },
				layout_strategy = "vertical",
				layout_config = { height = 0.95, width = 0.95, preview_height = 0.70 },
			},

			extensions = {
				live_grep_args = {
					auto_quoting = true,
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
			},
		})

		-- enable extensions
		telescope.load_extension("fzf") -- loads telescope-fzf-native.nvim
		telescope.load_extension("live_grep_args")

		local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
		local live_grep = telescope.extensions.live_grep_args

		-- Searching with <leader>s
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search for files within the CWD" })
		vim.keymap.set(
			"n",
			"<leader>sg",
			lga_shortcuts.grep_word_under_cursor,
			{ desc = "Live grep for item udner cursor" }
		)
		vim.keymap.set("n", "<leader>sg", live_grep.live_grep_args, { desc = "Live grep visual selection" })
		vim.keymap.set("v", "<leader>sg", lga_shortcuts.grep_visual_selection, { desc = "Live grep visual selection" })
		vim.keymap.set("n", "<C-f>", builtin.current_buffer_fuzzy_find, { desc = "ctrl + f" })
		vim.keymap.set(
			"n",
			"<leader>sm",
			":Telescope man_pages sections={'ALL'}<CR>",
			{ desc = "Search for man pages" }
		)
		vim.keymap.set(
			"n",
			"<leader>sc",
			builtin.spell_suggest,
			{ desc = "Check for the correct spelling under cursor" }
		)
		vim.keymap.set("n", "<leader>sa", builtin.builtin, { desc = "Display all Telescope options" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "View all keymaps made" })
		vim.keymap.set("n", "<leader>ss", builtin.keymaps, { desc = "Resume" })
	end,
}
