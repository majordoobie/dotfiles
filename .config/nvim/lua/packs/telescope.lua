-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════

-- Build telescope-fzf-native after install or update
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "telescope-fzf-native.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		end
	end,
})

vim.pack.add({
	git_source("nvim-telescope/telescope.nvim"),
	git_source("nvim-telescope/telescope-live-grep-args.nvim"),
	git_source("nvim-telescope/telescope-fzf-native.nvim"),
}, { load = true })

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
