-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════
vim.pack.add({
	git_source("fnune/recall.nvim"),
	{ src = git_source("ThePrimeagen/harpoon"), version = "harpoon2" },
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- [[
-- Create the typical book marks wrapped in the telescope UI
-- ]]
local recall = require("recall")
recall.setup({})

-- [[
-- Create file save points so that you can quickly move between all the files you are currently
-- manipulating
-- ]]
local harpoon = require("harpoon")
harpoon:setup({})

-- Harpoon telescope picker
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════

-- Recall marks
vim.keymap.set("n", "<leader>ms", recall.toggle, { noremap = true, silent = true, desc = "📌 Toggle mark" })
vim.keymap.set("n", "<leader>ml", recall.goto_next, { noremap = true, silent = true, desc = "⏭️  Next mark" })
vim.keymap.set("n", "<leader>mh", recall.goto_prev, { noremap = true, silent = true, desc = "⏮️  Previous mark" })
vim.keymap.set("n", "<leader>mc", recall.clear, { noremap = true, silent = true, desc = "🗑️  Clear marks" })
vim.keymap.set("n", "<leader>mm", ":Telescope recall<CR>", { noremap = true, silent = true, desc = "🔍 View all marks" })

vim.keymap.set("n", "<leader>m1", "`A", { desc = "📍 Jump to mark A" })
vim.keymap.set("n", "<leader>m2", "`B", { desc = "📍 Jump to mark B" })
vim.keymap.set("n", "<leader>m3", "`C", { desc = "📍 Jump to mark C" })
vim.keymap.set("n", "<leader>m4", "`D", { desc = "📍 Jump to mark D" })
vim.keymap.set("n", "<leader>m5", "`E", { desc = "📍 Jump to mark E" })

-- Harpoon
vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "🎯 Add file to harpoon" })
vim.keymap.set("n", "<leader>hh", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "📋 Harpoon menu" })
vim.keymap.set("n", "<leader>hv", function()
	toggle_telescope(harpoon:list())
end, { desc = "🔭 Harpoon telescope" })

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "1️⃣  Harpoon file 1" })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "2️⃣  Harpoon file 2" })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "3️⃣  Harpoon file 3" })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "4️⃣  Harpoon file 4" })
vim.keymap.set("n", "<leader>h5", function() harpoon:list():select(5) end, { desc = "5️⃣  Harpoon file 5" })
vim.keymap.set("n", "<leader>h6", function() harpoon:list():select(6) end, { desc = "6️⃣  Harpoon file 6" })
vim.keymap.set("n", "<leader>h7", function() harpoon:list():select(7) end, { desc = "7️⃣  Harpoon file 7" })
vim.keymap.set("n", "<leader>h8", function() harpoon:list():select(8) end, { desc = "8️⃣  Harpoon file 8" })
vim.keymap.set("n", "<leader>h9", function() harpoon:list():select(9) end, { desc = "9️⃣  Harpoon file 9" })
