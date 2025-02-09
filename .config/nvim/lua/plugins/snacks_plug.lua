-- cat neovim.cat | lolcat --truecolor --spread=10 --seed=20 --freq=.09 --force > neovim.cat2

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false, -- Force to load

	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"gf",
			function()
				Snacks.explorer()
			end,
			desc = "File explorer",
		},
	},

	opts = {
		-- Disable LSP when files are huge
		bigfile = { enable = true },

		-- Lets you get asked if you want to save a buffer
		bufdelete = { enable = true },
		words = { enable = true },

		styles = {
			notification_history = {
				width = 0.999,
				height = 0.999,
			},
		},

		-- Create the indent gutters to the left
		indent = {
			enable = true,
			hl = {
				"SnacksIndent1",
				"SnacksIndent2",
				"SnacksIndent3",
				"SnacksIndent4",
				"SnacksIndent5",
				"SnacksIndent6",
				"SnacksIndent7",
				"SnacksIndent8",
			},
		},
		-- Replaces Alpha
		dashboard = {
			enable = true,
			width = 72,
			preset = {
				keys = {
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{
					section = "terminal",
					cmd = "cat " .. vim.fn.stdpath("config") .. "/lua/plugins/neovim.cat",
					align = "center",
					height = 11,
					width = 72,
					padding = 0,
					hl = "header",
				},
				{
					title = "Menu",
					section = "keys",
					indent = 1,
					padding = 1,
					height = 20,
				},
				-- {title = "Recent Files", section = "recent_files", indent = 2, padding = 1},
				-- {title = "Projects", section = "projects", indent = 2, padding = 1 } ,
				{
					section = "terminal",
					icon = " ",
					title = "Git Status",
					enabled = vim.fn.isdirectory(".git") == 1,
					-- cmd = 'hub diff --stat -B -M -C',
					cmd = "hub status --short --branch --renames",
					height = 8,
					padding = 0,
					indent = 2,
				},
				{ section = "startup" },
			},
		},
	},
}
