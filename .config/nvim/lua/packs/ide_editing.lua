-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════
vim.pack.add({
	git_source("danymat/neogen"),
	git_source("0x00-ketsu/autosave.nvim"),
	git_source("windwp/nvim-autopairs"),
	git_source("linux-cultist/venv-selector.nvim"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- [[
-- Add doc strings to the highlighted function
-- ]]
require("neogen").setup({
	languages = { python = { template = { annotation_convention = "reST" } } },
})

-- [[
-- Allows for automatic saving of files that have changed. You can toggle the
-- plugin with
--
-- Toggle plug <leader>ts
-- ]]
require("autosave").setup({
	prompt = {
		enable = false,
		style = "",
		message = "Saved",
	},
})

-- Since we don't have any notifications, just tell the user that
-- the plugin is active when booting up
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.g.autosave_state then
			vim.notify("💾 Autosave is active", vim.log.levels.INFO, { title = "Autosave Status" })
		else
			vim.notify("💾 Autosave is inactive", vim.log.levels.WARN, { title = "Autosave Status" })
		end
	end,
})

-- [[
-- Auto close pairs with treesitter integration
-- ]]
require("nvim-autopairs").setup({
	check_ts = true, -- Enable treesitter integration
	ts_config = {
		lua = { "string", "source" }, -- Don't add pairs in lua string nodes
		javascript = { "string", "template_string" },
		python = { "string" },
	},
	disable_filetype = { "TelescopePrompt", "vim" },
})

-- [[
-- Python virtual environment selector
-- ]]
local function shorter_name(filename)
	return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
end

-- Store original vim.notify before venv-selector loads
local original_notify = vim.notify
local lualine_funcs = require("custom.lualine_functions")

require("venv-selector").setup({
	options = {
		notify_user_on_venv_activation = true,
		on_telescope_result_callback = shorter_name,
		statusline_func = {
			lualine = lualine_funcs.get_venv_name,
		},
	},
	search = {},
})

-- Restore vim.notify after venv-selector setup (it overrides in init.lua)
vim.schedule(function()
	if type(vim.notify) ~= "function" and type(original_notify) == "function" then
		vim.notify = original_notify
	end
end)

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════
vim.keymap.set({ "n", "v" }, "<leader>ed", function()
	require("neogen").generate({ type = "func" })
end, { desc = "📝 Generate docstring" })

vim.keymap.set("n", "<leader>ts", ":ASToggle<CR>", { desc = "💾 Toggle autosave" })

vim.keymap.set(
	"n",
	"<leader>sl",
	"<cmd>VenvSelect<cr>",
	{ desc = "✏️  Toggle python venv", silent = true, noremap = true }
)
