-- List of plugins that do not require any configurations
return {
	{
		-- lua functions that many plugins use
		"nvim-lua/plenary.nvim",
		lazy = true,
	},
	{
		--[[
        -- Open a binary file in hex view
        --]]
		"RaafatTurki/hex.nvim",
		config = function()
			require("hex").setup({})
		end,
	},
	{
		-- [[
		--  Allows for seamless integration with tmux by allowing you to
		--  use "ctrl + hjkl"
		-- ]]
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	{
		-- [[
		-- Render markdown so that it is prettier to look at
		-- ]]
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
      render_modes = true,
			completions = { blink = { enabled = true }, lsp = { enabled = true } },
			heading = {
				border = true,
				border_virtual = true,
				sign = true,
				position = "inline",
				width = "full",
			},
		},
	},
}
