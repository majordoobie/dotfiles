return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",

		-- [[  Extensions ]]
		-- Allows passing args to ripgrep
		"nvim-telescope/telescope-live-grep-args.nvim",
		-- undo tree
		"debugloop/telescope-undo.nvim",

		-- Makes searching faster
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		-- ============================================================================
		-- SETUP
		-- ============================================================================
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local lga_actions = require("telescope-live-grep-args.actions")
		local undo_actions = require("telescope-undo.actions")

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

		-- ============================================================================
		-- TELESCOPE CONFIGURATION
		-- ============================================================================
		telescope.setup({
			defaults = {
				path_display = { "absolute" },
			},
			extensions = {
				undo = {
					mappings = {
						i = {
							["<cr>"] = undo_actions.yank_additions,
							["<S-cr>"] = undo_actions.yank_deletions,
							["<C-cr>"] = undo_actions.restore,
							["<C-y>"] = undo_actions.yank_deletions,
							["<C-r>"] = undo_actions.restore,
						},
						n = {
							["y"] = undo_actions.yank_additions,
							["Y"] = undo_actions.yank_deletions,
							["u"] = undo_actions.restore,
						},
					},
				},
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
		telescope.load_extension("undo")

		-- ============================================================================
		-- DYNAMIC LAYOUT WRAPPER
		-- ============================================================================
		local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
		local live_grep = telescope.extensions.live_grep_args

		local function wrap_with_dynamic_layout(tbl)
			local original = {}
			for name, func in pairs(tbl) do
				if type(func) == "function" then
					original[name] = func
					tbl[name] = function(opts)
						opts = vim.tbl_deep_extend("force", get_dynamic_layout(), opts or {})
						return original[name](opts)
					end
				end
			end
		end

		wrap_with_dynamic_layout(builtin)
		wrap_with_dynamic_layout(lga_shortcuts)
		wrap_with_dynamic_layout(live_grep)
		wrap_with_dynamic_layout(telescope.extensions.undo)

		-- ============================================================================
		-- KEYMAPS
		-- ============================================================================
		local map = vim.keymap.set

		-- ══════════════════════════════════════════════════════════════
		-- ⏪ Undo Tree
		-- ══════════════════════════════════════════════════════════════
		map("n", "<leader>u", "<cmd>Telescope undo<cr>", { desc = "⏪ Undo tree" })

		-- ══════════════════════════════════════════════════════════════
		-- 🔍 File & Text Search
		-- ══════════════════════════════════════════════════════════════
		local builtin = require("telescope.builtin")

		-- Normal: source-first (tracked + optionally untracked)
		vim.keymap.set("n", "<leader>sf", function()
			builtin.git_files({ show_untracked = true })
		end, { desc = "Find files (git)" })

		-- Fallback: truly search filesystem, but still exclude build
		vim.keymap.set("n", "<leader>sF", function()
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
		end, { desc = "Find files (all, no build)" })

		map("n", "<leader>sg", live_grep.live_grep_args, { desc = "🔍 Live grep (with args)" })
		map("n", "<leader>sg", function()
		map("n", "<leader>sg", function()
			live_grep.live_grep_args({
				default_text = [[""]],
			})
			-- move cursor inside the quotes
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", false)
			end, 10)
		end, { desc = "🔍 Live grep (quoted)" })
			live_grep.live_grep_args({
				default_text = [[""]],
			})
			-- move cursor inside the quotes
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", false)
			end, 10)
		end, { desc = "🔍 Live grep (quoted)" })
		map("n", "<leader>sG", lga_shortcuts.grep_word_under_cursor, { desc = "🎯 Grep word under cursor" })
		map("v", "<leader>sg", lga_shortcuts.grep_visual_selection, { desc = "🔍 Grep selection" })

		-- ══════════════════════════════════════════════════════════════
		-- 🛠️  Utilities
		-- ══════════════════════════════════════════════════════════════
		map("n", "<C-f>", builtin.current_buffer_fuzzy_find, { desc = "🔎 Find in buffer" })
		map("n", "<leader>sm", builtin.man_pages, { desc = "📖 Man pages" })
		map("n", "<leader>sp", builtin.spell_suggest, { desc = "✏️  Spelling suggestions" })
		map("n", "<leader>sa", builtin.builtin, { desc = "🔭 All pickers" })
		map("n", "<leader>sk", builtin.keymaps, { desc = "⌨️  Search keymaps" })
		map("n", "<leader>ss", builtin.resume, { desc = "▶️  Resume picker" })
	end,
}
