-- sable V + k and V + j; they get in the way when moving quickly
vim.keymap.set("v", "<S-k>", "<Nop>")
vim.keymap.set("v", "<S-j>", "<Nop>")

-- Change the ^ and $ to easier to type keys
vim.keymap.set("n", "gh", "^")
vim.keymap.set("n", "gl", "$")
vim.keymap.set("v", "gh", "^")
vim.keymap.set("v", "gl", "$")

--  -- Modify Copy and paste
vim.keymap.set("n", "<leader>p", '"+p') -- Paste from global buffer
vim.keymap.set("v", "<leader>p", '"+p') -- Paste from global buffer

vim.keymap.set("n", "<leader>y", '"+y') -- Copy into global buffer
vim.keymap.set("v", "<leader>y", '"+y') -- Copy into global buffer

vim.keymap.set("n", "<leader>d", '"_d') -- Delete without affecting the unamged buffer
vim.keymap.set("v", "<leader>d", '"_d') -- Delete without affecting the unamed buffer

vim.keymap.set("x", "<leader>p", '"_dP') -- Delete without affecting buffer then paste

vim.keymap.set("n", "x", '"_x') -- Delete without affecting the unamged buffer
vim.keymap.set("v", "x", '"_x') -- Delete without affecting the unamed buffer

vim.keymap.set("n", "r", '"_r') -- Delete without affecting the unamged buffer
vim.keymap.set("v", "r", '"_r') -- Delete without affecting the unamed buffer

-- free up keybindings for zen
vim.api.nvim_set_keymap("n", "zc", "zz", { desc = "Center text to screen", noremap = true, silent = true })

vim.api.nvim_set_keymap(
	"n",
	"<leader>cp",
	':lua vim.fn.setreg("+", vim.fn.expand("%:p"))<CR>',
	{ noremap = true, silent = true, desc = "Copy path of open file" }
)

-- Use escape to escape the terminal
--vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<CR>", ":noh<CR><CR>")

-- window management
vim.keymap.set("n", "<leader>_", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>x", ":close<CR>", { desc = "Close current split" })

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<leader>tl", ":tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<leader>th", ":tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<leader>tc", ":tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

local function ToggleSpellWithNotify()
	local setting = not (vim.opt.spell:get())
	vim.opt.spell = setting

	-- Check the new state and notify the user
	if setting then
		vim.notify("Spell check eNABLED", vim.log.levels.INFO, { title = "Spell" })
	else
		vim.notify("Spell check dISABLED", vim.log.levels.INFO, { title = "Spell" })
	end
end

vim.keymap.set("n", "<leader>st", ToggleSpellWithNotify, { desc = "Toggle spelling", silent = true, noremap = true })
