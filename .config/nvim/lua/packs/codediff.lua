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

## Merge Conflicts
NOTE: codediff is a VSCode-style 3-way merge editor. It PARSES OUT the
<<<<<<< ======= >>>>>>> markers and splits them into three buffers:
incoming (theirs) | result | current (ours). Conflict regions are shown as
▌ signs in the gutter, NOT as markers:
    orange = unresolved   green = accepted   red = rejected   gray = resolved
Navigate with ]x / [x rather than scanning for the signs.

" Resolve conflicts in the current file        (<leader>gc)
:CodeDiff merge /abs/path/to/file

" During a merge, conflicted files get their own group in the explorer
:CodeDiff

Per-hunk:   <leader>ct incoming   <leader>co current   <leader>cb both   <leader>cx discard
Whole file: <leader>cT incoming   <leader>cO current   <leader>cB both   <leader>cX discard
Vimdiff:    2do get incoming      3do get current

------------------------------------------------------------

## PR-like Diff (merge-base)
" Only YOUR changes since branching — like a Pull Request  (<leader>gm)
:CodeDiff main...

" Committed changes only (excludes working tree)
:CodeDiff main...HEAD

" Merge-base between two branches
:CodeDiff develop...feature/new-ui

" Same, scoped to the current file
:CodeDiff file main...

------------------------------------------------------------

## In any diff view
g?    Show ALL keymaps active in this view (floating window)
t     Toggle side-by-side / inline layout
ih    Hunk textobject (vih select, yih yank)
-     Stage/unstage current file
<leader>hs / <leader>hu / <leader>hr   Stage / unstage / discard hunk
gm    Align other pane to paired moved code (needs diff.compute_moves = true)



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
local fileshare = require("config.fileshare")

local codediff_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/codediff.nvim"
local lib_ext = vim.fn.has("mac") == 1 and "dylib" or "so"
local is_airgapped = fileshare.is_airgapped()

-- On air-gapped: disable codediff's built-in GitHub auto-installer (no internet).
-- On internet: leave it enabled so codediff fetches its binary from GitHub releases on first use.
if is_airgapped then
	vim.env.VSCODE_DIFF_NO_AUTO_INSTALL = "1"
end

-- Copy codediff's prebuilt native diff library (per-tag) from the fileshare, plus the
-- Linux-only libgomp shim when present. The ABI is tied to the plugin tag, so the match
-- must be exact.
local function copy_from_fileshare()
	return fileshare.copy_tag_matched_binary({
		name = "codediff",
		plugin_path = codediff_path,
		subdir = "codediff.nvim",
		source_tmpl = "codediff.nvim-libvscode_%s.so",
		dest = function(tag)
			local version_num = tag:gsub("^v", "")
			return codediff_path .. "/libvscode_diff_" .. version_num .. "." .. lib_ext
		end,
		post = function(tag, path)
			-- Linux systems without OpenMP need libgomp.so.1 alongside the main binary.
			if lib_ext ~= "so" then
				return
			end
			local gomp_source = fileshare.fileshare_root()
				.. "/codediff.nvim/codediff.nvim-libgomp_"
				.. tag
				.. ".so.1"
			if vim.uv.fs_stat(gomp_source) then
				vim.uv.fs_copyfile(gomp_source, path .. "/libgomp.so.1")
			end
		end,
	})
end

-- On air-gapped: re-copy the binary from the fileshare when vim.pack installs or updates codediff.
-- On internet: no hook needed — codediff's built-in installer fetches from GitHub on first use.
if is_airgapped then
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			if ev.data.spec.name == "codediff.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
				copy_from_fileshare()
			end
		end,
	})
end

vim.pack.add({
	git_source("esmuellert/codediff.nvim"),
}, { load = true })

-- Ensure a usable binary is in place. On air-gapped: copy from the fileshare. On internet:
-- codediff's own installer handles the download on first use, so nothing to do here.
local has_binary = vim.fn.glob(codediff_path .. "/libvscode_diff*." .. lib_ext) ~= ""
if not has_binary and is_airgapped then
	copy_from_fileshare()
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
		layout = "side-by-side", -- Diff layout: "side-by-side" or "inline" (toggle at runtime with 't')
		disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
		max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
		ignore_trim_whitespace = false, -- Ignore leading/trailing whitespace changes (like diffopt+=iwhite)
		hide_merge_artifacts = false, -- Hide merge tool temp files (*.orig, *.BACKUP.*, *.BASE.*, *.LOCAL.*, *.REMOTE.*)
		original_position = "left", -- Position of original (old) content: "left" or "right"
		conflict_ours_position = "right", -- Position of ours (:2) in conflict view: "left" or "right"
		-- Conflict layout: "center" puts the result BETWEEN incoming/current as 3 columns
		-- (diffview-style). "bottom" squeezes it under the panes — much harder to track.
		conflict_result_position = "center",
		conflict_result_height = 30, -- Height of result buffer in "bottom" layout (% of total height)
		conflict_result_width_ratio = { 1, 2, 1 }, -- "center" layout {left, center, right} — double-width result
		cycle_next_hunk = true, -- Wrap around when navigating hunks (]c/[c)
		cycle_next_file = true, -- Wrap around when navigating files (]f/[f)
		jump_to_first_change = true, -- Auto-scroll to first change when opening a diff
		highlight_priority = 100, -- Priority for line-level diff highlights (raise to override LSP highlights)
		compute_moves = false, -- Detect moved code blocks (opt-in, may slow diff computation)
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
		focus_on_select = false, -- Jump to modified pane after selecting a file (false = stay in explorer)
		flatten_dirs = true, -- Flatten single-child directory chains in tree view (e.g., src/components/ui/)
		visible_groups = { -- Which groups to show (toggle at runtime with gs/gu)
			staged = true,
			unstaged = true,
			conflicts = true, -- During a merge, conflicted files get their own group
		},
		-- NOTE: file_filter.ignore intentionally omitted — an empty table would *replace*
		-- the plugin defaults ({".git/**", ".jj/**"}) rather than merge with them.
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
			focus_explorer = "<leader>e", -- Focus explorer panel (shadows the <leader>e edit prefix in diff views)
			next_hunk = "]c", -- Jump to next change
			prev_hunk = "[c", -- Jump to previous change
			next_file = "]f", -- Next file in explorer mode
			prev_file = "[f", -- Previous file in explorer mode
			diff_get = "do", -- Get change from other buffer (like vimdiff)
			diff_put = "dp", -- Put change to other buffer (like vimdiff)
			open_in_prev_tab = "gf", -- Open current buffer in previous tab (or new tab before current)
			close_on_open_in_prev_tab = false, -- Close codediff tab after opening in previous tab
			toggle_stage = "-", -- Stage/unstage current file (works in explorer AND diff buffers)
			stage_hunk = "<leader>hs", -- Stage the hunk under cursor to git index
			unstage_hunk = "<leader>hu", -- Unstage the hunk under cursor from git index
			discard_hunk = "<leader>hr", -- Discard the hunk under cursor (working tree only)
			hunk_textobject = "ih", -- Textobject for hunk (vih to select, yih to yank, etc.)
			align_move = "gm", -- Temporarily align other pane to show paired moved code
			toggle_layout = "t", -- Toggle side-by-side / inline for the current session
			show_help = "g?", -- 💡 Floating window listing every keymap active in this view
		},
		explorer = {
			select = "<CR>", -- Open diff for selected file
			hover = "K", -- Show file diff preview
			refresh = "R", -- Refresh git status
			toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
			stage_all = "S", -- Stage all files
			unstage_all = "U", -- Unstage all files
			restore = "X", -- Discard changes (restore file)
			toggle_changes = "gu", -- Toggle Changes (unstaged) group visibility
			toggle_staged = "gs", -- Toggle Staged Changes group visibility
			-- Fold keymaps (Vim-style, tree view)
			fold_open = "zo", -- Expand current node
			fold_open_recursive = "zO", -- Expand current node and all descendants
			fold_close = "zc", -- Collapse current node
			fold_close_recursive = "zC", -- Collapse current node and all descendants
			fold_toggle = "za", -- Toggle fold
			fold_toggle_recursive = "zA", -- Toggle fold recursively
			fold_open_all = "zR", -- Open all folds
			fold_close_all = "zM", -- Close all folds
		},
		history = {
			select = "<CR>", -- Select commit/file or toggle expand
			toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
			refresh = "R", -- Refresh history (re-fetch commits)
			-- Fold keymaps (Vim-style, directory nodes only)
			fold_open = "zo",
			fold_open_recursive = "zO",
			fold_close = "zc",
			fold_close_recursive = "zC",
			fold_toggle = "za",
			fold_toggle_recursive = "zA",
			fold_open_all = "zR",
			fold_close_all = "zM",
		},
		conflict = {
			accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
			accept_current = "<leader>co", -- Accept current (ours/right) change
			accept_both = "<leader>cb", -- Accept both changes (incoming first)
			discard = "<leader>cx", -- Discard both, keep base
			-- Whole-file variants (uppercase, like diffview)
			accept_all_incoming = "<leader>cT", -- Accept ALL incoming changes
			accept_all_current = "<leader>cO", -- Accept ALL current changes
			accept_all_both = "<leader>cB", -- Accept ALL both changes
			discard_all = "<leader>cX", -- Discard ALL, reset to base
			next_conflict = "]x", -- 🎯 Jump to next conflict — don't hunt for the ▌ signs, jump
			prev_conflict = "[x", -- 🎯 Jump to previous conflict
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
-- Resolve the repo's default branch instead of hardcoding "main" — air-gapped
-- GitLab repos may still be on "master". Runs on keypress, not at startup.
local function default_branch()
	local head = vim.system({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" }, { text = true }):wait()
	if head.code == 0 then
		return (vim.trim(head.stdout):gsub("^origin/", ""))
	end
	for _, branch in ipairs({ "main", "master" }) do
		if vim.system({ "git", "rev-parse", "--verify", "--quiet", branch }, { text = true }):wait().code == 0 then
			return branch
		end
	end
	return "main"
end

vim.keymap.set("n", "<leader>gm", function()
	vim.cmd("CodeDiff " .. default_branch() .. "...")
end, { desc = "🔀 PR diff (merge-base vs default branch)" })
-- :CodeDiff merge takes a literal path (no % expansion), so expand it here.
vim.keymap.set("n", "<leader>gc", function()
	vim.cmd("CodeDiff merge " .. vim.fn.fnameescape(vim.fn.expand("%:p")))
end, { desc = "⚔️  Resolve conflicts in this file" })
