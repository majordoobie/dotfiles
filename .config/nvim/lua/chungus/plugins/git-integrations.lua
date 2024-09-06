
return {
    {
        -- Powerful plugin is responsible for showing the differences between commits by file or 
        -- worktree
	    "sindrets/diffview.nvim",
        dependencies = {
            {"nvim-tree/nvim-web-devicons" },
        },
        config = function()
            require("diffview").setup({
                enhanced_diff_view = true,
                default_args = {
                    DiffviewOpen = {"--imply-local"},
                },
            })
            -- Git diff commands
            vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>")
            vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", {desc = "View history of file"})
            vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory<CR>", {desc = "View history of branch"})

        end
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
	    	{"nvim-lua/plenary.nvim"},
	    	{"sindrets/diffview.nvim"},
            {"nvim-tree/nvim-web-devicons" },
            {"nvim-telescope/telescope.nvim"},
        },
        config = function()
            require("neogit").setup({
                kind = "tab",
                integrations = {diffview = true}
            })
            vim.keymap.set("n", "<leader>go", ":Neogit<CR>",  {desc = "Open up the NeoGit menu"})

        end
    },
    {
        "lewis6991/gitsigns.nvim",
        event = {"BufReadPre", "BufNewFile"},
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                  local gitsigns = require('gitsigns')

                  local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                  end

                  -- Actions
                  map("n", "<leader>gk", gitsigns.preview_hunk)
                  map("n", "<leader>gr", gitsigns.reset_hunk)
                  map("n", "<leader>gn", gitsigns.next_hunk)
                  map("n", "<leader>gp", gitsigns.prev_hunk)
                end
            })
        end
    },
    {
        "FabijanZulj/blame.nvim",
        config = function()
            require("blame").setup{}
            vim.keymap.set("n", "<leader>gb", ":BlameToggle<CR>")
        end
    }
}
