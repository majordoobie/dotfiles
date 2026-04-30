-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════

local fzf_native_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
local lib_ext = vim.fn.has("mac") == 1 and "dylib" or "so"

local function build_fzf_native(cwd)
	if vim.fn.isdirectory(cwd) == 0 then
		vim.api.nvim_echo({
			{ "⚠️  telescope-fzf-native dir missing: " .. cwd, "ErrorMsg" },
		}, true, {})
		return
	end
	vim.api.nvim_echo({ { "Building telescope-fzf-native in " .. cwd, "WarningMsg" } }, true, {})
	vim.cmd("redraw")
	local ok, result = pcall(function()
		return vim.system({ "make" }, { cwd = cwd, text = true }):wait()
	end)
	if not ok then
		vim.api.nvim_echo({
			{ "⚠️  telescope-fzf-native: could not run make: " .. tostring(result), "ErrorMsg" },
		}, true, {})
		return
	end
	if result.code == 0 then
		vim.api.nvim_echo({ { "✅ telescope-fzf-native built!", "Normal" } }, true, {})
	else
		vim.api.nvim_echo({
			{
				"⚠️  telescope-fzf-native build failed (exit "
					.. tostring(result.code)
					.. "):\nstdout: "
					.. (result.stdout or "")
					.. "\nstderr: "
					.. (result.stderr or ""),
				"ErrorMsg",
			},
		}, true, {})
	end
end

-- Build telescope-fzf-native after install or update
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "telescope-fzf-native.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
			build_fzf_native(ev.data.path)
		end
	end,
})

vim.pack.add({
	git_source("nvim-telescope/telescope.nvim"),
	git_source("nvim-telescope/telescope-live-grep-args.nvim"),
	git_source("nvim-telescope/telescope-fzf-native.nvim"),
}, { load = true })

-- Fallback: if the native binary is missing (e.g. PackChanged didn't fire, prior build failed,
-- or the build dir was wiped), build it now before telescope.load_extension("fzf") runs.
local fzf_so = fzf_native_path .. "/build/libfzf." .. lib_ext
if vim.fn.filereadable(fzf_so) == 0 then
	build_fzf_native(fzf_native_path)
end

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════
local telescope = require("telescope")
local builtin = require("telescope.builtin")
local lga_actions = require("telescope-live-grep-args.actions")

-- Dynamic layout: vertical for wide screens, horizontal for narrow
-- Screen dimensions: MacBook Pro (131x36), External Monitor (222x54)
local function get_dynamic_layout()
	if vim.o.columns >= 200 then
		return {
			layout_strategy = "vertical",
			layout_config = { height = 0.95, width = 0.95, preview_height = 0.6 },
		}
	else
		return {
			layout_strategy = "horizontal",
			layout_config = { height = 0.95, width = 0.95, preview_width = 0.55 },
		}
	end
end

telescope.setup({
	defaults = {
		path_display = { "absolute" },
	},
	extensions = {
		live_grep_args = {
			auto_quoting = true,
			additional_args = function(_)
				return {
					"--glob=!build/**",
					"--glob=!**/build/**",
				}
			end,
			mappings = {
				i = {
					["<C-k>"] = lga_actions.quote_prompt(),
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					["<C-space>"] = lga_actions.to_fuzzy_refine,
				},
			},
		},
		fzf = {
			case_mode = "smart_case",
		},
	},
})

-- Load extensions
telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")

-- Dynamic layout wrapper
local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
local live_grep = telescope.extensions.live_grep_args

local function wrap_with_dynamic_layout(tbl)
	local original = {}
	for name, func in pairs(tbl) do
		if type(func) == "function" then
			original[name] = func
			tbl[name] = function(opts)
				opts = vim.tbl_deep_extend("force", opts or {}, get_dynamic_layout())
				return original[name](opts)
			end
		end
	end
end

wrap_with_dynamic_layout(builtin)
wrap_with_dynamic_layout(lga_shortcuts)
wrap_with_dynamic_layout(live_grep)
-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════
local map = vim.keymap.set

-- 🔍 File & Text Search
map("n", "<leader>sf", function()
	builtin.git_files({ show_untracked = true })
end, { desc = "🔍 Find files (git)" })

map("n", "<leader>sF", function()
	builtin.find_files({
		hidden = true,
		find_command = {
			"fd",
			"--type",
			"f",
			"--hidden",
			"--exclude",
			".git",
			"--exclude",
			"build",
			"--exclude",
			"**/build/**",
		},
	})
end, { desc = "🔍 Find files (all, no build)" })

map("n", "<leader>sg", function()
	live_grep.live_grep_args({
		default_text = [[""]],
	})
	vim.defer_fn(function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", false)
	end, 10)
end, { desc = "🔍 Live grep (quoted)" })
map("n", "<leader>sG", lga_shortcuts.grep_word_under_cursor, { desc = "🎯 Grep word under cursor" })
map("v", "<leader>sg", lga_shortcuts.grep_visual_selection, { desc = "🔍 Grep selection" })

-- 🛠️  Utilities
map("n", "<C-f>", builtin.current_buffer_fuzzy_find, { desc = "🔎 Find in buffer" })
map("n", "<leader>sm", builtin.man_pages, { desc = "📖 Man pages" })
map("n", "<leader>sp", builtin.spell_suggest, { desc = "✏️  Spelling suggestions" })
map("n", "<leader>sa", builtin.builtin, { desc = "🔭 All pickers" })
map("n", "<leader>sk", builtin.keymaps, { desc = "⌨️  Search keymaps" })
map("n", "<leader>ss", builtin.resume, { desc = "▶️  Resume picker" })
