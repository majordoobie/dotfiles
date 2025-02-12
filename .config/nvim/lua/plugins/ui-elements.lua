return {
	{
		-- [[
		-- Wraps any function that uses the vim.ui.select() to make it prettier
		-- ]]
		"stevearc/dressing.nvim",
		opts = {},
	},

	{
        -- [[
        -- Adds virtual line text for diagnostic information
        -- ]]
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					-- Display the source of the diagnostic (e.g., basedpyright, vsserver, lua_ls etc.)
					show_source = true,
                    -- time it takes for things to update.
                    throttle = 0,
				},
			})
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end,
	},

	{
		-- [[
		-- Customizes the messages, cmdline and the popupmenu
		-- to make them more "prettier"
		-- ]]
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
				--]]
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
			})
			local noice = require("noice")
			vim.keymap.set("n", "<leader>nh", function()
				noice.cmd("telescope")
			end, { desc = "Noice history view" })
			vim.keymap.set("n", "<leader>nn", function()
				noice.cmd("dismiss")
			end, { desc = "Noice dismiss notifications" })
			vim.keymap.set("n", "<leader>ns", function()
				noice.cmd("stats")
			end, { desc = "Noice stats" })
			vim.keymap.set("n", "<leader>ne", function()
				noice.cmd("errors")
			end, { desc = "Noice show errros" })
		end,
	},
	{
		-- [[
		-- Creates the LUA line in the bottom of the open buffer
		-- ]]
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				extensions = {
					"oil",
					"toggleterm",
					"fzf",
					"man",
					"nvim-dap-ui",
				},
				options = {
					theme = "catppuccin",
				},
				sections = {
					lualine_a = { "mode", "searchcount" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "diagnostics", "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "filesize" },
					lualine_z = { "progress", "location" },
				},
			})
		end,
	},
	{
		-- [[
		-- Toggle a floating terminal
		-- ]]
		"akinsho/toggleterm.nvim",

		config = function()
			require("toggleterm").setup({
				direction = "float",
				float_opts = {
					border = "curved",
				},
			})

			-- allow the use of <C-q> to change back to "normal" mode
			vim.keymap.set("t", "<C-q>", "<C-\\><C-n>")
			vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>", { desc = "Open terminal in floating window" })
		end,
	},

	{
		--[[
        -- Centers the code so that you are not stuck looking to the left
        -- or right side of the text editor
        --]]
		"shortcuts/no-neck-pain.nvim",
		config = function()
			require("no-neck-pain").setup({
				width = 170,
			})
			vim.keymap.set("n", "Z", ":NoNeckPain<CR>", { desc = "Toggle zen mode" })
		end,
	},
	{
		-- [[
		-- Full screens whatever you are looking at even if it is a split tab
		-- ]]
		"Pocco81/true-zen.nvim",
		config = function()
			require("true-zen").setup({})
			vim.keymap.set("n", "<leader>z", ":TZFocus<CR>", { desc = "Toggle pane maximization" })
		end,
	},
	{
		-- [[
		-- Provides the breadcrumb above the text editor
		-- ]]
		"Bekaboo/dropbar.nvim",
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	{
		-- [[
		-- Provides a way to manipulate the file system with a vim buffer
		-- ]]
		"stevearc/oil.nvim",
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
					end,
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
		end,
	},
}
