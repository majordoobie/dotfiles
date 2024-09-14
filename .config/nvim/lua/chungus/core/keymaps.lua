-- set leader key to space
vim.g.mapleader = " "

-- sable V + k and V + j; they get in the way when moving quickly
vim.keymap.set("v", "<S-k>", "<Nop>")
vim.keymap.set("v", "<S-j>", "<Nop>")

-- Open netRW
vim.keymap.set("n", "<leader>gf", ":Ex<CR>")

-- Change the ^ and $ to easier to type keys
vim.keymap.set("n", "gh", "^")
vim.keymap.set("n", "gl", "$")
vim.keymap.set("v", "gh", "^")
vim.keymap.set("v", "gl", "$")

-- -- Update how indentation works
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
  
--  -- Modify Copy and paste
vim.keymap.set("n", "<leader>p", "\"+p")   -- Paste from global buffer
vim.keymap.set("v", "<leader>p", "\"+p")   -- Paste from global buffer

vim.keymap.set("n", "<leader>y", "\"+y")   -- Copy into global buffer
vim.keymap.set("v", "<leader>y", "\"+y")   -- Copy into global buffer

vim.keymap.set("n", "<leader>d", "\"_d")   -- Delete without affecting the unamged buffer
vim.keymap.set("v", "<leader>d", "\"_d")   -- Delete without affecting the unamed buffer

vim.keymap.set("x", "<leader>p", "\"_dP")  -- Delete without affecting buffer then paste

vim.keymap.set("n", "x", "\"_x")           -- Delete without affecting the unamged buffer
vim.keymap.set("v", "x", "\"_x")           -- Delete without affecting the unamed buffer

vim.keymap.set("n", "r", "\"_r")           -- Delete without affecting the unamged buffer
vim.keymap.set("v", "r", "\"_r")           -- Delete without affecting the unamed buffer

-- Use escape to escape the terminal 
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")           -- Delete without affecting the unamed buffer


-- window management
vim.keymap.set("n", "<leader>_", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>x", ":close<CR>", { desc = "Close current split" }) -- close current split window

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<leader>tl", ":tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<leader>th", ":tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<leader>tc", ":tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

