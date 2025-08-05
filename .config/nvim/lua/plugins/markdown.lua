return {
	-- [[
	-- Render markdown so that it is prettier to look at
	-- ]]
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("render-markdown").setup({
			ft = { "markdown", "quarto" },

			-- render_modes = { "n", "c", "t" },
			render_modes = true,

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
				language_left = "",
				language_right = "",
			},

			checkbox = {
				unchecked = { icon = "󰄱" },
				checked = { icon = "󰱒" },
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
			pipe_table = { preset = "round" },
			quote = { repeat_linebreak = true },
		})
		vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#26233a" })
	end,
}
