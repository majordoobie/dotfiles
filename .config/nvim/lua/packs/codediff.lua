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

-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════
-- Disable auto-download of binary (we manage it via fileshare/gsync)
vim.env.VSCODE_DIFF_NO_AUTO_INSTALL = "1"

vim.pack.add({
	git_source("esmuellert/codediff.nvim"),
}, { load = true })

-- Ensure codediff binary exists, fallback chain:
-- 1. Check fileshare for prebuilt binary (air-gapped network)
-- 2. Use :CodeDiff install to download from GitHub releases
local codediff_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/codediff.nvim"
local fileshare_path = "/mnt/software/Neovim"
local lib_ext = vim.fn.has("mac") == 1 and "dylib" or "so"
local has_codediff_binary = vim.fn.glob(codediff_path .. "/libvscode_diff*." .. lib_ext) ~= ""

if vim.fn.isdirectory(codediff_path) == 1 and not has_codediff_binary then
	-- Try to copy prebuilt binary from fileshare (version-agnostic glob)
	local fileshare_binary = vim.fn.glob(fileshare_path .. "/codediff.nvim/codediff.nvim-libvscode_*.so")
	if fileshare_binary ~= "" then
		-- Extract clean version from filename (e.g. "codediff.nvim-libvscode_v2.43.10.so" -> "2.43.10")
		local version_num = fileshare_binary:match("_v(%d+%.%d+%.%d+)%.so$")
		if version_num then
			local dest = codediff_path .. "/libvscode_diff_" .. version_num .. "." .. lib_ext
			vim.api.nvim_echo(
				{ { "Copying codediff binary from fileshare (may be slow)...", "WarningMsg" } },
				true,
				{}
			)
			vim.cmd("redraw")
			vim.uv.fs_copyfile(fileshare_binary, dest)
			vim.api.nvim_echo({ { "codediff binary copied from fileshare!", "Normal" } }, true, {})
		end
	else
		-- Fallback: let codediff download it on first use via :CodeDiff install
		vim.api.nvim_echo(
			{ { "codediff binary not found, run :CodeDiff install to download", "WarningMsg" } },
			true,
			{}
		)
	end
end

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════
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

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>gd", "<cmd>CodeDiff<cr>", { desc = "📊 Git diff explorer" })
vim.keymap.set("n", "<leader>gf", "<cmd>CodeDiff file HEAD<cr>", { desc = "📄 Diff file vs HEAD" })
vim.keymap.set("n", "<leader>gh", "<cmd>CodeDiff history<cr>", { desc = "📜 File git history" })
