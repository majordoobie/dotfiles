return {
	{
		-- [[
		-- LuaSnip is a snippet engine. You can create your own keybindings but
		-- for now I'm just using the ones provided by "friendly-snippets"
		-- ]]
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
			-- Some C snippets can be found at: https://github.com/Harry-Ross/vscode-c-snippets
			-- some good ones: "if", "for", "cal"
			"rafamadriz/friendly-snippets", -- useful snippets
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		priority = 100,

		dependencies = {
			-- Allows the use of L3MON4D3/LuaSnip to be a completion source
			"saadparwaiz1/cmp_luasnip",

			-- buffer
			"hrsh7th/cmp-path", -- source for file system paths
			"hrsh7th/cmp-buffer", -- `buffer` source for text in buffer
			"hrsh7th/cmp-nvim-lsp-signature-help", -- display a signature when you start typing the func name
			"hrsh7th/cmp-nvim-lsp-document-symbol", -- display a signature when you start typing the func name

			-- lsp
			"hrsh7th/cmp-nvim-lsp",

			-- adds emoji to the selection
			"onsails/lspkind.nvim",

			-- command completions
			"hrsh7th/cmp-cmdline",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,preview,noselect",
				},

				-- specify the snippet engine to be used
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
				}),

				-- sources for autocompletion
				sources = cmp.config.sources({
					-- Priority Source
					{ name = "nvim_lsp" }, -- Get completion from LSP
					{ name = "luasnip" }, -- Adds LuaSnip as a completion source

					{ name = "nvim_lsp_signature_help" }, -- show func parameters
					{ name = "path" }, -- file system paths
				}, {

					-- Secondary source
					{ name = "buffer" }, -- text within current buffer
				}),

				-- configure lspkind for vs-code like pictograms in completion menu
				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
						menu = {
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
						},
					}),
				},
			})

			-- Override navigation keys for example:
            -- These don't seem to work it is ignored
			local cmdline_mapping = cmp.mapping.preset.cmdline()
			cmdline_mapping["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            cmdline_mapping["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })


			-- Command-line completion for the ':' prompt
			cmp.setup.cmdline(":", {
				mapping = cmdline_mapping,
				sources = cmp.config.sources({
					{ name = "cmdline" }, -- fallback to command-line completions
					{ name = "path" },
				}),
			})

			-- Command-line completion for the '/' (and '?') prompt, using buffer words
            -- You have to use <C-n> and <C-p> for navigation can't seem to fix this
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmdline_mapping,
				sources = cmp.config.sources({
					-- Activate symbols with "@"
					{ name = "nvim_lsp_document_symbol" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
