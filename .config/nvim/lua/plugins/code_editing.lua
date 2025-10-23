local function shorter_name(filename)
	return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
end

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
			end, { desc = "📝 Generate docstring" })
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
			vim.keymap.set("n", "<leader>ts", ":ASToggle<CR>", { desc = "💾 Toggle autosave" })
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
		opts = {
			check_ts = true, -- Enable treesitter integration
			ts_config = {
				lua = { "string", "source" }, -- Don't add pairs in lua string nodes
				javascript = { "string", "template_string" },
				python = { "string" },
			},
			disable_filetype = { "TelescopePrompt", "vim" },
		},
	},

	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		ft = "python",
		config = function()
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

			vim.keymap.set(
				"n",
				"<leader>sl",
				"<cmd>VenvSelect<cr>",
				{ desc = "✏️  Toggle python venv", silent = true, noremap = true }
			)

			-- Restore vim.notify after venv-selector setup (it overrides in init.lua)
			vim.schedule(function()
				if type(vim.notify) ~= "function" and type(original_notify) == "function" then
					vim.notify = original_notify
				end
			end)
		end,
	},
}
