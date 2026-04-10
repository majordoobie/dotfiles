-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════
vim.pack.add({
	git_source("stevearc/oil.nvim"),
	git_source("nvim-tree/nvim-web-devicons"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- [[
-- Provides a way to manipulate the file system with a vim buffer
-- ]]
local oil = require("oil")
oil.setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,

	-- Enable LSP file operations (rename/move files updates imports)
	lsp_file_operations = {
		enabled = true,
		autosave_changes = true,
	},

	-- Watch for external changes to keep oil buffers in sync
	watch_for_changes = true,

	columns = {
		"icon",
		"size",
		"permissions",
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
		list = true,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	float = {
		max_width = 0.9,
		max_height = 0.9,
		preview_split = "right",
		border = "rounded",
	},
	constrain_cursor = "name",
	keymaps = {
		["<C-p>"] = "actions.preview",
		["q"] = { "actions.close", mode = "n" },
		["-"] = { "actions.parent", mode = "n" },
	},
})

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "-", oil.open_float, { desc = "📁 Open file explorer" })
