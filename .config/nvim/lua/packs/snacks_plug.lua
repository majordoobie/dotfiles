-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════

-- cat neovim.cat | lolcat --truecolor --spread=10 --seed=20 --freq=.09 --force > neovim.cat2

vim.pack.add({
	git_source("folke/snacks.nvim"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════
require("snacks").setup({

	-- enable viewing images in neovim
	image = { enable = true },

	-- disable lsp on a huge file
	bigfile = { enabled = true },

	-- Disable file explorer
	explorer = { enabled = false },

	-- Override vim.ui.input to make a pretty box
	input = { enabled = true },

	-- We use telescope for a picker
	picker = { enabled = false },

	-- Disable notifier since we're using noice.nvim for notifications
	notifier = { enabled = false },

	-- dont need any of these
	quickfile = { enabled = false },
	scope = { enabled = false },
	scroll = { enabled = false },
	statuscolumn = { enabled = false },
	words = { enabled = false },

	terminal = {
		win = {
			width = 0.95,
			height = 0.95,
			position = "float",
			border = "rounded",
		},
		interactive = true,
		shell = "fish",
	},

	-- Lets you get asked if you want to save a buffer
	bufdelete = { enable = true },

	-- [[
	-- Enable Zen editing to remove distractions
	-- ]]
	zen = {
		win = {
			wo = {
				wrap = false,
			},
		},
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
		input = {
			relative = "cursor",
		},
		zen = {
			width = 120,
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
					icon = "📂 ",
					key = "r",
					desc = "Recent Files",
					action = ":lua Snacks.dashboard.pick('oldfiles')",
				},
				{
					icon = "⚙️  ",
					key = "c",
					desc = "Config",
					action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
				},
				{
					icon = "📦 ",
					key = "p",
					desc = "Plugin Update",
					action = ":lua vim.pack.update()",
				},
				{ icon = "❌ ", key = "q", desc = "Quit", action = ":qa" },
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
			{
				section = "terminal",
				icon = " ",
				title = "Git Status",
				enabled = vim.fn.isdirectory(".git") == 1,
				cmd = "git status --short --branch",
				height = 8,
				padding = 0,
				indent = 2,
			},
		},
	},
})

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Open LazyGit in a floating window" })

vim.keymap.set("n", "<leader>z", function()
	Snacks.zen.zen()
end, { desc = "Enter zen mode" })

vim.keymap.set("n", "<leader>Z", function()
	Snacks.zen.zoom()
end, { desc = "Zoom into file closing panes" })

vim.keymap.set("n", "<C-t>", function()
	Snacks.terminal()
end, { desc = "Open terminal" })

vim.keymap.set("n", "<leader>gw", function()
	Snacks.gitbrowse()
end, { desc = "Open the current file on GitLab/GitHub" })
