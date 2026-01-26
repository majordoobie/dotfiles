--[[
=================================================================================================
CodeDiff REFERENCE & CONFIGURATION
=================================================================================================

Git Configuration (run these commands in your terminal):
---------------------------------------------------------

# Set up merge tool
git config --global merge.tool codediff
git config --global mergetool.codediff.cmd 'nvim "$MERGED" -c "CodeDiff merge \"$MERGED\""'

# Set up diff tool
git config --global diff.tool codediff
git config --global difftool.codediff.cmd 'nvim "$LOCAL" "$REMOTE" +"CodeDiff file $LOCAL $REMOTE"'


# Use tools
git difftool                      # View all uncommitted changes
git difftool HEAD~2 HEAD          # Compare two commits
git difftool main feature-branch  # Compare branches
git difftool -y                   # Skip confirmation prompts






------------------------------------------------------------
## File Explorer
" Show git status in explorer (default)
:CodeDiff

" Show changes for specific revision in explorer
:CodeDiff HEAD~5

" Compare against a branch
:CodeDiff main

" Compare against a specific commit
:CodeDiff abc123

" Compare two revisions (e.g. HEAD vs main)
:CodeDiff main HEAD

------------------------------------------------------------

## Git Diff
" Compare with last commit
:CodeDiff file HEAD

" Compare with previous commit
:CodeDiff file HEAD~1

" Compare with specific commit
:CodeDiff file abc123

" Compare with branch
:CodeDiff file main

" Compare with tag
:CodeDiff file v1.0.0

" Compare two revisions for current file
:CodeDiff file main HEAD

------------------------------------------------------------

## File Comparison

:CodeDiff file file_a.txt file_b.txt

" Auto-detect directories
:CodeDiff ~/project-v1 ~/project-v2

" Explicit dir subcommand
:CodeDiff dir /path/to/dir1 /path/to/dir2


------------------------------------------------------------

## History
" Compare with last commit
:CodeDiff file HEAD

" Compare with previous commit
:CodeDiff file HEAD~1

" Compare with specific commit
:CodeDiff file abc123

" Compare with branch
:CodeDiff file main

" Compare with tag
:CodeDiff file v1.0.0

" Compare two revisions for current file
:CodeDiff file main HEAD

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
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
		config = function()
			require("codediff").setup({
				-- Highlight configuration
				highlights = {
					-- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
					line_insert = "DiffAdd", -- Line-level insertions
					line_delete = "DiffDelete", -- Line-level deletions

					-- Character-level: accepts highlight group names or hex colors
					-- If specified, these override char_brightness calculation
					char_insert = nil, -- Character-level insertions (nil = auto-derive)
					char_delete = nil, -- Character-level deletions (nil = auto-derive)

					-- Brightness multiplier (only used when char_insert/char_delete are nil)
					-- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
					char_brightness = nil, -- Auto-adjust based on your colorscheme

					-- Conflict sign highlights (for merge conflict views)
					-- Accepts highlight group names or hex colors (e.g., "#f0883e")
					-- nil = use default fallback chain
					conflict_sign = nil, -- Unresolved: DiagnosticSignWarn -> #f0883e
					conflict_sign_resolved = nil, -- Resolved: Comment -> #6e7681
					conflict_sign_accepted = nil, -- Accepted: GitSignsAdd -> DiagnosticSignOk -> #3fb950
					conflict_sign_rejected = nil, -- Rejected: GitSignsDelete -> DiagnosticSignError -> #f85149
				},

				-- Diff view behavior
				diff = {
					disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
					max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
					hide_merge_artifacts = false, -- Hide merge tool temp files (*.orig, *.BACKUP.*, *.BASE.*, *.LOCAL.*, *.REMOTE.*)
					original_position = "left", -- Position of original (old) content: "left" or "right"
					conflict_ours_position = "right", -- Position of ours (:2) in conflict view: "left" or "right"
				},

				-- Explorer panel configuration
				explorer = {
					position = "left", -- "left" or "bottom"
					width = 40, -- Width when position is "left" (columns)
					height = 15, -- Height when position is "bottom" (lines)
					indent_markers = true, -- Show indent markers in tree view (│, ├, └)
					initial_focus = "explorer", -- Initial focus: "explorer", "original", or "modified"
					icons = {
						folder_closed = "", -- Nerd Font folder icon (customize as needed)
						folder_open = "", -- Nerd Font folder-open icon
					},
					view_mode = "list", -- "list" or "tree"
					file_filter = {
						ignore = {}, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
					},
				},

				-- History panel configuration (for :CodeDiff history)
				history = {
					position = "bottom", -- "left" or "bottom" (default: bottom)
					width = 40, -- Width when position is "left" (columns)
					height = 15, -- Height when position is "bottom" (lines)
					initial_focus = "history", -- Initial focus: "history", "original", or "modified"
					view_mode = "list", -- "list" or "tree" for files under commits
				},

				-- Keymaps in diff view
				keymaps = {
					view = {
						quit = "q", -- Close diff tab
						toggle_explorer = "<leader>b", -- Toggle explorer visibility (explorer mode only)
						next_hunk = "]c", -- Jump to next change
						prev_hunk = "[c", -- Jump to previous change
						next_file = "]f", -- Next file in explorer mode
						prev_file = "[f", -- Previous file in explorer mode
						diff_get = "do", -- Get change from other buffer (like vimdiff)
						diff_put = "dp", -- Put change to other buffer (like vimdiff)
					},
					explorer = {
						select = "<CR>", -- Open diff for selected file
						hover = "K", -- Show file diff preview
						refresh = "R", -- Refresh git status
						toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
						toggle_stage = "-", -- Stage/unstage selected file
						stage_all = "S", -- Stage all files
						unstage_all = "U", -- Unstage all files
						restore = "X", -- Discard changes (restore file)
					},
					history = {
						select = "<CR>", -- Select commit/file or toggle expand
						toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
					},
					conflict = {
						accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
						accept_current = "<leader>co", -- Accept current (ours/right) change
						accept_both = "<leader>cb", -- Accept both changes (incoming first)
						discard = "<leader>cx", -- Discard both, keep base
						next_conflict = "]x", -- Jump to next conflict
						prev_conflict = "[x", -- Jump to previous conflict
						diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
						diffget_current = "3do", -- Get hunk from current (right/ours) buffer
					},
				},
			})
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
