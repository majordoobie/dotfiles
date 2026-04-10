-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════
vim.pack.add({
	git_source("lewis6991/gitsigns.nvim"),
	git_source("FabijanZulj/blame.nvim"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- [[
-- Awesome plugin is able to show you what has changed in the current line.
-- You can even revert the current line back to what it was in the commit
-- ]]
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "<leader>gn", function()
			if vim.wo.diff then
				vim.cmd.normal({ "<leader>gn", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "⏭️  Next hunk" })

		map("n", "<leader>gp", function()
			if vim.wo.diff then
				vim.cmd.normal({ "<leader>gp", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "⏮️  Previous hunk" })

		-- Actions
		map("n", "<leader>gk", gitsigns.preview_hunk, { desc = "👁️  Preview hunk" })
		map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "↩️  Reset hunk" })
	end,
})

-- [[
-- Show git blame
-- ]]
require("blame").setup()

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>gb", ":BlameToggle<CR>", { desc = "👤 Toggle git blame" })
