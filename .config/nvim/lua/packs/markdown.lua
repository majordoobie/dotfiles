-- ══════════════════════════════════════════════════════════════
-- 📦 Plugins
-- ══════════════════════════════════════════════════════════════
vim.pack.add({
	git_source("MeanderingProgrammer/render-markdown.nvim"),
}, { load = true })

-- ══════════════════════════════════════════════════════════════
-- ⚙️  Configurations
-- ══════════════════════════════════════════════════════════════

-- [[
-- Render markdown so that it is prettier to look at
-- ]]
require("render-markdown").setup({
	file_types = { "markdown", "quarto", "codecompanion" },
	-- render_modes = { "n", "c", "t" },
	render_modes = true,

	-- Disable latex to avoid warnings about missing latex parsers
	latex = { enabled = false },

	completions = { blink = { enabled = true }, lsp = { enabled = true } },

	bullet = {
		icons = { "●", "○", "◆", "◇" },
	},

	code = {
		enabled = true,
		sign = true,
		style = "full",
		position = "left",
		left_pad = 2,
		right_pad = 2,
		language_border = " ",
		language_left = "",
		language_right = "",
	},

	heading = {
		enabled = true,
		sign = true,
		position = "inline",
		width = "full",
		border = false,
		border_virtual = false,
		above = "▄",
		below = "▀",
	},

	indent = {
		enabled = true,
		render_modes = false,
		per_level = 2,
		skip_level = 1,
		skip_heading = false,
		icon = "▎",
		priority = 0,
		highlight = "RenderMarkdownIndent",
	},
	-- cell = "trimmed" subtracts whitespace already in the source from the
	-- rendered width, so <leader>ef-aligned tables are not padded twice.
	pipe_table = { preset = "round", cell = "trimmed" },
	quote = { repeat_linebreak = true },

	-- GitLab renders [~] as an "inapplicable" task item (upstream ships only [-])
	checkbox = {
		unchecked = { icon = "󰄱" },
		checked = { icon = "󰱒" },
		custom = {
			todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
			inapplicable = { raw = "[~]", rendered = "󰍴 ", highlight = "RenderMarkdownUnchecked" },
		},
	},
})
vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#26233a" })

-- ══════════════════════════════════════════════════════════════
-- ⌨️  Keybindings
-- ══════════════════════════════════════════════════════════════

-- Preview through the GitLab instance's own renderer (exact GLFM, resolved refs)
vim.api.nvim_create_user_command("GitLabPreview", function()
	require("custom.gitlab_preview").preview()
end, { desc = "Render current buffer via GitLab's markdown API" })

vim.keymap.set("n", "<leader>gl", function()
	require("custom.gitlab_preview").preview()
end, { desc = "🦊 GitLab markdown preview" })
