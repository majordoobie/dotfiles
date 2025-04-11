return {
	{
		--[[
        -- Able to see the history of the current file side by side just like in clion
        --]]
		"sindrets/diffview.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		config = function()
			local actions = require("diffview.actions")
			require("diffview").setup({
				enhanced_diff_view = true,
				default_args = {
					DiffviewOpen = { "--imply-local" },
				},
				views = {
					merge_tool = {
						-- Config for conflicted files in diff views during a merge or rebase.
						layout = "diff3_mixed",
						disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = true, -- See |diffview-config-view.x.winbar_info|
					},
				},

				keymaps = {
					disable_defaults = false, -- Disable the default keymaps
					view = {
						{
							"n",
							"<leader>e",
							actions.focus_files,
							{ desc = "Bring focus to the file panel" },
						},
						{
							"n",
							"<leader>b",
							actions.toggle_files,
							{ desc = "Toggle the file panel." },
						},
						{
							"n",
							"g<C-x>",
							actions.cycle_layout,
							{ desc = "Cycle through available layouts." },
						},
					},
				},
			})

			-- Git diff commands
			vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>")
			vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "View history of file" })
			vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory<CR>", { desc = "View history of branch" })
		end,
	},
	{
		-- [[
		-- Awesome plugin is able to show you what has changed in the current line.
		-- You can even revert the current line back to what it was in the commit
		-- ]]
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
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
					end)

					map("n", "<leader>gp", function()
						if vim.wo.diff then
							vim.cmd.normal({ "<leader>gp", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end)

					-- Actions
					map("n", "<leader>gk", gitsigns.preview_hunk)
					map("n", "<leader>gr", gitsigns.reset_hunk)
				end,
			})
		end,
	},
	{
		-- [[
		-- Show git blame
		-- ]]
		"FabijanZulj/blame.nvim",
		config = function()
			require("blame").setup()
			vim.keymap.set("n", "<leader>gb", ":BlameToggle<CR>")
		end,
	},
}
