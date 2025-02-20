-- cat neovim.cat | lolcat --truecolor --spread=10 --seed=20 --freq=.09 --force > neovim.cat2

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false, -- Force to load

	keys = {
		{ "<leader>gg", function() Snacks.lazygit() end,        desc = "Open LazyGit in a floating window", },
		{ "gf", function() Snacks.explorer() end,               desc = "Open file explorer tree", },
        { "<leader>z", function() Snacks.zen.zen() end,         desc = "Enter zen mode", },
        { "<leader>Z", function() Snacks.zen.zoom() end,        desc = "Zoom into file closing panes", },
        { "<C-t>",     function() Snacks.terminal() end,        desc = "Open terminal"},
        { "<leader>gw", function() Snacks.gitbrowse() end,      desc = "Open the current file on GitLab/GitHub"}
	},

	opts = {
		-- Disable LSP when files are huge
		bigfile = { enable = true },

		-- Lets you get asked if you want to save a buffer
		bufdelete = { enable = true },

        -- Override vim.ui.input to make a pretty box
		input = { enable = true },

        -- [[
        -- Enable Zen editing to remove distractions
        -- ]]
		zen = {
			toggles = {
				dim = false,
			},
			show = {
				statusline = true,
				tabline = true,
			},
		},

        -- [[
        -- Enable Indenting guides on the left
        -- ]]
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


        -- [[
        -- Change the styles of the plugins
        -- ]]
		styles = {
			notification_history = {
				width = 0.999,
				height = 0.999,
			},
			input = {
				relative = "cursor",
			},
			zen = {
				width = 180,
			},
		},

        -- [[
        -- Create a welcome page when you run "nvim" by itself
        -- ]]
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
				{ section = "header" },
				{ title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{
					title = "Menu",
					section = "keys",
					indent = 1,
					padding = 1,
					height = 20,
				},
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
