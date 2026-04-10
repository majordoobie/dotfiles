-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════
vim.pack.add({
	{ src = git_source("catppuccin/nvim"), name = "catppuccin" },
	git_source("arnamak/stay-centered.nvim"),
	git_source("MunifTanjim/nui.nvim"),
	git_source("rcarriga/nvim-notify"),
	git_source("folke/noice.nvim"),
	git_source("nvim-lualine/lualine.nvim"),
	git_source("Bekaboo/dropbar.nvim"),
	git_source("folke/which-key.nvim"),
	git_source("nvim-treesitter/nvim-treesitter-context"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- [[
-- Catppuccin colorscheme
-- ]]
require("catppuccin").setup({
	transparent_background = true,
	flavour = "macchiato",
	integrations = {
		diffview = true,
		mini = {
			enabled = true,
		},
		dropbar = {
			enabled = true,
			color_mode = true,
		},
		snacks = {
			enabled = true,
			indent_scope_color = "",
		},
		fidget = true,
		gitsigns = true,
		nvimtree = true,
		harpoon = true,
		notify = true,
		markdown = true,
		noice = true,
		notifier = true,
		dap = true,
		dap_ui = true,
		treesitter_context = true,
		treesitter = true,
		render_markdown = true,
		which_key = true,
		blink_cmp = true,
		telescope = {
			enabled = true,
		},
	},
})
vim.cmd.colorscheme("catppuccin")

-- [[
-- stay-centered - keeps cursor centered on screen
-- ]]
require("stay-centered").setup({})

-- [[
-- Customizes the messages, cmdline and the popupmenu
-- to make them more "prettier"
-- ]]
require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
		signature = { enabled = false },
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = true,
	},
})

-- [[
-- Creates the LUA line in the bottom of the open buffer
-- ]]
local lualine_funcs = require("custom.lualine_functions")
local colors = lualine_funcs.bubble_theme()
require("lualine").setup({
	extensions = {
		"oil",
		"toggleterm",
		"fzf",
		"man",
		"nvim-dap-ui",
	},
	options = {
		theme = "catppuccin-macchiato",
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
			"venv-selector",
		},
	},
})

-- [[
-- Provides the breadcrumb above the text editor
-- ]]
-- dropbar.nvim works out of the box, no setup needed

-- [[
-- which-key - displays available keybindings in popup
-- ]]
require("which-key").setup({})

-- [[
-- Shows code context at the top of the window
-- (e.g., the function/class you're currently in as you scroll)
-- ]]
require("treesitter-context").setup({
	enable = true,
	max_lines = 3, -- How many lines of context to show
	min_window_height = 0, -- Minimum editor window height to enable context
	line_numbers = true,
	multiline_threshold = 20, -- Maximum number of lines to show for a single context
	trim_scope = "outer", -- Which context lines to discard if max_lines is exceeded
	mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
	zindex = 20, -- The Z-index of the context window
})

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════

-- Noice
local noice = require("noice")
vim.keymap.set("n", "<leader>nh", function()
	noice.cmd("telescope")
end, { desc = "📜 Message history" })
vim.keymap.set("n", "<leader>nn", function()
	noice.cmd("dismiss")
end, { desc = "❌ Dismiss notifications" })
vim.keymap.set("n", "<leader>ns", function()
	noice.cmd("stats")
end, { desc = "📊 Noice stats" })
vim.keymap.set("n", "<leader>ne", function()
	noice.cmd("errors")
end, { desc = "⚠️  Show errors" })

--
-- Treesitter context
vim.keymap.set("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Jump to context (function start)" })
