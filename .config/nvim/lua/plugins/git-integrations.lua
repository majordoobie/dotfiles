--[[
=================================================================================================
NVIMDIFF REFERENCE & CONFIGURATION
=================================================================================================

Git Configuration (run these commands in your terminal):
---------------------------------------------------------
git config --global merge.tool nvimdiff
git config --global mergetool.nvimdiff.layout "(LOCAL,BASE,REMOTE) / MERGED"
git config --global mergetool.prompt false
git config --global diff.tool nvimdiff
git config --global difftool.nvimdiff.cmd 'nvim -d "$LOCAL" "$REMOTE"'


Usage:
------
git mergetool                    # Open nvimdiff for merge conflicts
git difftool                     # Compare uncommitted changes with HEAD
git difftool HEAD~1              # Compare with previous commit
nvim -d file1.txt file2.txt      # Compare two files directly


During Merge Conflict (4 windows):
-----------------------------------
┌─────────────┬─────────────┬─────────────┐
│   LOCAL     │    BASE     │   REMOTE    │
│ (your code) │ (ancestor)  │ (their code)│
├─────────────┴─────────────┴─────────────┤
│              MERGED                      │
│         (result you're editing)          │
└──────────────────────────────────────────┘


Essential Keybindings (in diff mode):
--------------------------------------
]c                  → Jump to next change
[c                  → Jump to previous change
do                  → Diff obtain (get changes from other window)
dp                  → Diff put (put changes to other window)
:diffget LOCAL      → Get changes from LOCAL window
:diffget REMOTE     → Get changes from REMOTE window
:diffget BASE       → Get changes from BASE window
:diffupdate         → Recalculate diffs
zo                  → Open fold
zc                  → Close fold
:wqa                → Write all and quit
:cq                 → Quit and abort merge


Advanced Commands:
------------------
:diffthis           → Make current window part of diff
:diffoff            → Turn off diff mode
:set diffopt+=iwhite → Ignore whitespace in diffs
Ctrl-w Ctrl-w       → Switch between windows
Ctrl-w =            → Equalize window sizes


Workflows:
----------
# Compare local file with remote branch
nvim -d myfile.py <(git show origin/main:myfile.py)

# Compare with specific commit
nvim -d myfile.py <(git show abc123:myfile.py)

# Compare current file with HEAD
nvim -d myfile.py <(git show HEAD:myfile.py)

=================================================================================================
--]]

-- Recommended diff mode settings
vim.opt.diffopt:append("vertical") -- Always use vertical splits for diffs
vim.opt.diffopt:append("internal") -- Use Neovim's internal diff library
vim.opt.diffopt:append("filler") -- Show filler lines for deleted content
vim.opt.diffopt:append("closeoff") -- Turn off diff mode when only one window remains
vim.opt.diffopt:append("algorithm:histogram") -- Use better diff algorithm

-- Optional: Improve diff mode highlights (uncomment if you want custom colors)
-- vim.cmd([[
--   highlight DiffAdd    guifg=#00ff00 guibg=#005500
--   highlight DiffChange guifg=#cccccc guibg=#555500
--   highlight DiffDelete guifg=#ff0000 guibg=#550000
--   highlight DiffText   guifg=#ffff00 guibg=#888800
-- ]])

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
				view = {
					merge_tool = {
						-- Config for conflicted files in diff views during a merge or rebase.
						layout = "diff3_mixed",
						disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
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
			vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "🔍 Git diff view" })
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
		end,
	},
	{
		-- [[
		-- Show git blame
		-- ]]
		"FabijanZulj/blame.nvim",
		config = function()
			require("blame").setup()
			vim.keymap.set("n", "<leader>gb", ":BlameToggle<CR>", { desc = "👤 Toggle git blame" })
		end,
	},
}
