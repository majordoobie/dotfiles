return {
	{
		-- [[
		-- Proper completion for lua so that it can understand
		-- neovim lua configs
		-- ]]
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- [[
		-- Replaces nvim-cmp + LuaSnip engine for a compiled completion engine
		-- with all the sources included.
		--
		-- To accept: ctrl + y
		-- ]]
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",
		-- use a release tag to download pre-built binaries
		version = "*",
		opts = {
			keymap = {
				preset = "default",
				["<C-enter>"] = { "accept", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			sources = {
				-- add lazydev to your completion providers
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
			-- Displays the signature while adding the parameters of the function
			-- you are working on.
			signature = {
				enabled = true,
				window = {
					scrollbar = true,
					border = "rounded",
				},
			},
			completion = {
				-- Enable blink.cmp's built-in auto-brackets (works alongside nvim-autopairs)
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},

				-- As you scroll through the selection it will show docs for the selection
				-- to the right of the selection window
				documentation = { auto_show = true, auto_show_delay_ms = 100, window = { border = "rounded" } },

				-- allows to visually see what is going to be filled in
				ghost_text = { enabled = false },

				menu = {
					border = "rounded",
					draw = {
						align_to = "label",
						columns = {
							{ "kind_icon" },
							{ "label" },
							{ "label_description" },
							{ "source_name" },
						},
						components = {
							source_name = {
								width = { max = 30 },
								text = function(ctx)
									return "[" .. ctx.source_name .. "]"
								end,
								highlight = "BlinkCmpSource",
							},
						},
					},
				},
			},
			cmdline = { completion = { ghost_text = { enabled = false } } },
		},
		opts_extend = { "sources.default" },
	},
}
