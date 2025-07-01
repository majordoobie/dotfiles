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

		-- Dynamic layout function
		local function get_dynamic_layout()
			if vim.o.columns >= 200 then
				return {
					layout_strategy = "vertical",
					layout_config = {
						height = 0.95,
						width = 0.95,
						preview_height = 0.6,
					},
				}
			else
				return {
					layout_strategy = "horizontal",
					layout_config = {
						height = 0.95,
						width = 0.95,
						preview_width = 0.55,
					},
				}
			end
		end

		telescope.setup({
			-- 131; 36 -- macbook pro dimensions
			-- 222; 54 -- external monitor dimensions

			defaults = {
				path_display = { "absolute" },
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

		-- Wrap all builtin functions to use dynamic layout
		local original_builtin = {}
		for name, func in pairs(builtin) do
			original_builtin[name] = func
			builtin[name] = function(opts)
				opts = vim.tbl_deep_extend("force", get_dynamic_layout(), opts or {})
				return original_builtin[name](opts)
			end
		end

		-- Wrap lga_shortcuts functions
		local original_lga_shortcuts = {}
		for name, func in pairs(lga_shortcuts) do
			original_lga_shortcuts[name] = func
			lga_shortcuts[name] = function(opts)
				opts = vim.tbl_deep_extend("force", get_dynamic_layout(), opts or {})
				return original_lga_shortcuts[name](opts)
			end
		end

		-- Wrap live_grep extension functions
		local original_live_grep = {}
		for name, func in pairs(live_grep) do
			original_live_grep[name] = func
			live_grep[name] = function(opts)
				opts = vim.tbl_deep_extend("force", get_dynamic_layout(), opts or {})
				return original_live_grep[name](opts)
			end
		end

		--
		-- Searching with <leader>s
		--

		-- File search commands
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search for files within the CWD" })
		vim.keymap.set("n", "<leader>sf", function()
			builtin.find_files({ glob_pattern = "!.git/", no_ignore = true, no_parent_ignore = true })
		end, { desc = "Search for any file ignoring rules" })

		-- Grep commands
		vim.keymap.set("n", "<leader>sg", live_grep.live_grep_args, { desc = "Enter live grep mode" })

		vim.keymap.set(
			"n",
			"<leader>sG",
			lga_shortcuts.grep_word_under_cursor,
			{ desc = "Live grep for item under cursor" }
		)
		vim.keymap.set("v", "<leader>sg", lga_shortcuts.grep_visual_selection, { desc = "Live grep visual selection" })

		-- Utilities
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

		-- Debug command to check window dimensions
		vim.keymap.set("n", "<leader>sd", function()
			print("Columns: " .. vim.o.columns .. ", Lines: " .. vim.o.lines)
		end, { desc = "Debug window dimensions" })
	end,
}
