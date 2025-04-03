return {
	{
		-- [[
		-- Add doc strings to the highlighted function
		-- ]]
		"danymat/neogen",
		config = function()
			require("neogen").setup({
				vim.keymap.set("v", "<leader>ed", ":Neogen<CR>", { desc = "Apply docstring to function" }),
			})
		end,
	},
	{
		-- [[
		-- Allows for automatic saving of files that have changed. You can toggle the
		-- plugin with
		--
		-- Toggle plug <leader>es
		-- ]]
		"0x00-ketsu/autosave.nvim",
		config = function()
			local autosave = require("autosave")
			autosave.setup({
				prompt_style = "",
				event = { "InsertLeave", "TextChanged" },
			})
			vim.keymap.set("n", "<leader>es", ":ASToggle<CR>", { desc = "undo tree" })
		end,
		-- Since we don't have any notifications, just tell the user that
		-- the plugin is active when booting up
		init = function()
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.g.autosave_state then
						vim.notify("💾 Autosave is active", vim.log.levels.INFO, { title = "Autosave Status" })
					else
						vim.notify("💾 Autosave is inactive", vim.log.levels.WARN, { title = "Autosave Status" })
					end
				end,
			})
		end,
	},

	{
		--[[
        -- Visit all the undo changes with a tree view so that you can select the changes
        -- and bring them to the present if you wanted to.
        --]]
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			local undotree = require("undotree")
			undotree.setup({})
			vim.keymap.set("n", "<leader>u", undotree.toggle, { desc = "undo tree" })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
        opts = {}
	},
}
