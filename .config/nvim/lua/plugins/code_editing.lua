return {
	{
		-- [[
		-- Add doc strings to the highlighted function
		-- ]]
		"danymat/neogen",
		config = function()
			local neogen = require("neogen")
			neogen.setup({
				languages = { python = { template = { annotation_convention = "reST" } } },
			})
			vim.keymap.set({ "n", "v" }, "<leader>ed", function()
				neogen.generate({ type = "func" })
			end, { desc = "Apply docstring to function" })
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
			require("autosave").setup({
				prompt = {
					enable = false,
					style = "",
					message = "Saved",
				},
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
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
}
