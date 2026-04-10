-- ══════════════════════════════════════════════════════════════
-- 📦 Neovim Built-in Optional Plugins
-- ══════════════════════════════════════════════════════════════
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nohlsearch") -- auto-clears search highlight when cursor moves
vim.cmd.packadd("nvim.tohtml") -- convert buffer to HTML with syntax highlighting via :TOhtml

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════

-- ⏪ Undo Tree (Neovim 0.12 built-in)
vim.keymap.set("n", "<leader>u", function()
	require("undotree").open({ command = "50vnew" })
end, { desc = "⏪ Undo tree" })
