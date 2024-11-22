return {
    {
        -- LuaSnip is a snippiting engine. You can create your own keybindings but
        -- for now I'm just using the ones provided by "friendly-snippets"
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
            end
        }
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
            "hrsh7th/cmp-buffer", -- source for text in buffer
            "amarakon/nvim-cmp-buffer-lines", -- source for whole function prototypes
            "hrsh7th/cmp-nvim-lsp-signature-help", -- display a signature when you start typing the func name

            -- lsp
            "hrsh7th/cmp-nvim-lsp",

            -- adds emojis to the selection
            "onsails/lspkind.nvim",        

            -- adds spell words to suggestions
            "f3fora/cmp-spell"
        },

        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                snippet = { -- configure how nvim-cmp interacts with snippet engine
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
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                -- sources for autocompletion
                sources = cmp.config.sources({
                    { name = "nvim_lsp"},
                    { name = "nvim_lsp_signature_help"}, -- show func parameters
                    { name = "buffer-lines"},
                    { name = "luasnip" }, -- Adds LuaSnip as a completion source
                    { name = "buffer" }, -- text within current buffer
                    { name = "path" }, -- file system paths
                    { name = "spell" }, -- adds spelling suggestions to the cmp list
                }),

                -- configure lspkind for vs-code like pictograms in completion menu
                formatting = {
                    format = lspkind.cmp_format({
                            maxwidth = 50,
                            ellipsis_char = "...",
                        }),
                    },
            })
        end,
    },
}
