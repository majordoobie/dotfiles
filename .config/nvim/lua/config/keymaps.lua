-- Disable Shift+J and Shift+K in visual mode (prevents accidental movements)
vim.keymap.set("v", "<S-k>", "<Nop>", { desc = "Disabled" })
vim.keymap.set("v", "<S-j>", "<Nop>", { desc = "Disabled" })

-- ══════════════════════════════════════════════════════════════
-- 🧭 Navigation - Easier line start/end movements
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "gh", "^", { desc = "⬅️  Go to line start" })
vim.keymap.set("n", "gl", "$", { desc = "➡️  Go to line end" })
vim.keymap.set("v", "gh", "^", { desc = "⬅️  Go to line start" })
vim.keymap.set("v", "gl", "$", { desc = "➡️  Go to line end" })

-- ══════════════════════════════════════════════════════════════
-- 📋 Clipboard - System clipboard operations
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>y", '"+y', { desc = "📋 Copy to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "📋 Copy to system clipboard" })

-- ══════════════════════════════════════════════════════════════
-- 🗑️  Delete - Using black hole register (doesn't affect clipboard)
-- ══════════════════════════════════════════════════════════════
-- d/dd/D use default behavior (yank + delete) so you can cut and paste
vim.keymap.set("n", "x", '"_x', { desc = "🗑️  Delete char (no yank)" })
vim.keymap.set("v", "x", '"_x', { desc = "🗑️  Delete selection (no yank)" })
vim.keymap.set("n", "r", '"_r', { desc = "🗑️  Replace char (no yank)" })
vim.keymap.set("v", "r", '"_r', { desc = "🗑️  Replace selection (no yank)" })

-- ══════════════════════════════════════════════════════════════
-- 📝 Smart Paste - Replace without yanking deleted text
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("x", "p", '"_dP', { desc = "📝 Paste (keep clipboard)" })

-- ══════════════════════════════════════════════════════════════
-- 🎯 Utilities
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "zc", "zz", { desc = "🎯 Center screen on cursor", noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>cp",
	':lua vim.fn.setreg("+", vim.fn.expand("%:p"))<CR>',
	{ noremap = true, silent = true, desc = "📂 Copy file path" }
)
-- nohlsearch built-in plugin auto-clears search highlight when cursor moves
vim.keymap.set("n", "<leader>w", ":set wrap!<CR>", { desc = "Toggle line wrap" })

-- ══════════════════════════════════════════════════════════════
-- 🪟 Window Management
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>_", "<C-w>v", { desc = "🪟 Split vertically" })
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "🪟 Split horizontally" })
vim.keymap.set("n", "<leader>q", ":close<CR>", { desc = "❌ Close window" })

-- ══════════════════════════════════════════════════════════════
-- 📑 Tab Management
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "➕ New tab" })
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "❌ Close tab" })
vim.keymap.set("n", "<leader>tl", ":tabn<CR>", { desc = "➡️  Next tab" })
vim.keymap.set("n", "<leader>th", ":tabp<CR>", { desc = "⬅️  Previous tab" })
vim.keymap.set("n", "<leader>tc", ":tabnew %<CR>", { desc = "📄 Open buffer in new tab" })

local function ToggleSpellWithNotify()
	local setting = not (vim.opt.spell:get())
	vim.opt.spell = setting

	-- Check the new state and notify the user
	if setting then
		vim.notify("Spell check ENABLED", vim.log.levels.INFO, { title = "Spell" })
	else
		vim.notify("Spell check DISABLED", vim.log.levels.INFO, { title = "Spell" })
	end
end

-- ══════════════════════════════════════════════════════════════
-- 📝 Spelling
-- ══════════════════════════════════════════════════════════════
vim.keymap.set(
	"n",
	"<leader>tp",
	ToggleSpellWithNotify,
	{ desc = "✏️  Toggle spell check", silent = true, noremap = true }
)
