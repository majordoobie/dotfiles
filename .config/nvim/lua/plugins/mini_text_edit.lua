-- [[
-- Mini is a collection of a ton of little plugins "mini plugins"
-- that are only active when setup is executed
-- ]]
return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- [[
			--Comment out the highlighted section with "gc"
			-- ]]
			require("mini.comment").setup({
				mappings = {
					comment = "<leader>ec",
					comment_visual = "<leader>ec",
				},
			})

			--[[
            -- Move selected text and move them around easily with
            -- ctrl + shift + hjkl
            -- --]]
			require("mini.move").setup({
				mappings = {
					-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
					left = "<C-H>",
					right = "<C-L>",
					down = "<C-J>",
					up = "<C-K>",

					line_left = "",
					line_right = "",
					line_down = "",
					line_up = "",
				},
			})

			-- [[
			-- Surround a word with something or remove them.
			-- This plugin can be repeated with the '.'
			-- ]]
			require("mini.surround").setup({
				mappings = {
					add = "sa", -- Add surrounding in Normal and Visual modes
					delete = "sd", -- Delete surrounding
					find = "sf", -- Find surrounding (to the right)
					find_left = "sF", -- Find surrounding (to the left)
					highlight = "sh", -- Highlight surrounding
					replace = "sr", -- Replace surrounding
					update_n_lines = "sn", -- Update `n_lines`

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},
				custom_surroundings = {
					["["] = { output = { left = "[", right = "]" } },
					["]"] = { output = { left = "[", right = "]" } },
					["("] = { output = { left = "(", right = ")" } },
					[")"] = { output = { left = "(", right = ")" } },
					["{"] = { output = { left = "{", right = "}" } },
					["}"] = { output = { left = "{", right = "}" } },
				},
			})

			-- [[
			-- Display the last used files you have visited
			-- You can even tag things
			-- ]]
			require("mini.visits").setup()
			local visits = require("mini.visits")
			local pickers = require("custom.custom_pickers")

			vim.keymap.set("n", "<leader>hta", function()
				visits.add_label()
			end, { desc = "🏷️  Add visit label" })

			vim.keymap.set("n", "<leader>hts", function()
				visits.select_label()
			end, { desc = "🔖 Select visit label" })

			vim.keymap.set("n", "<leader>hs", function()
				pickers.toggle_telescope(visits.list_paths())
			end, { desc = "🗺️  View visited paths" })

			-- [[
			-- 	Auto highlight word under cursor
			-- ]]
			require("mini.cursorword").setup()

			-- [[
			-- Highlight common words and color groups
			-- ]]
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},
}
