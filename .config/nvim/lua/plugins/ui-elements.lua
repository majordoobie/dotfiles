return {
	{
		"arnamak/stay-centered.nvim",
		lazy = false,
		opts = {},
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
					override = {
						-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
					-- Use blink.cmp for signature
					signature = { enabled = false },
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
			local lualine_funcs = require("custom.lualine_functions")
      local colors = lualine_funcs.bubble_theme()
			require("lualine").setup({
				extensions = {
					"oil",
					"toggleterm",
					"fzf",
					"man",
					"nvim-dap-ui",
					"trouble",
				},
				options = {
					theme = "catppuccin",
					globalstatus = true,
					component_separators = "|",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = {
						{ "mode", separator = { left = "" }, right_padding = 2 },
						"searchcount",
						"selectioncount",
					},
					lualine_b = { "diagnostics", { "filename", path = 1 } },
					lualine_c = { "%=" },

					lualine_x = {},
					lualine_z = {
						{
							"branch",
							fmt = lualine_funcs.truncate_branch_name,
							separator = { right = "" },
							left_padding = 2,
						},
					},
					lualine_y = {
						"filetype",
						{
							lualine_funcs.get_lsp_client_name,
							icon = "LSP:",
							color = { fg = colors.mocha_blue, gui = "bold" },
						},
					},
				},
			})
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
			local oil = require("oil")
			oil.setup({
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
					cursorcolumn = true,
					list = true,
					conceallevel = 3,
					concealcursor = "nvic",
				},
				float = {
					max_width = 0.8,
					max_height = 0.8,
					preview_split = "right",
				},
				constrain_cursor = "name",
			})

			vim.keymap.set("n", "-", oil.open_float, { desc = "Open parent directory" })
		end,
	},
}
