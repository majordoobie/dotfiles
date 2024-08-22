
return {
    {
        "NeogitOrg/neogit",
        dependencies = {
	    	{"nvim-lua/plenary.nvim"},
	    	{"sindrets/diffview.nvim"},
            {"nvim-tree/nvim-web-devicons" },
            {"nvim-telescope/telescope.nvim"},
        },
        config = function()
            local neogit = require("neogit").setup({
                kind = "split",
                integrations = {diffview = true}
            })

            vim.keymap.set("n", "<leader>go", ":Neogit<CR>",  {desc = "Open up the NeoGit menu"})
            vim.keymap.set("n", "<leader>gl", ":Neogit log<CR>", {desc = "Open up the NeoGit menu"})
            vim.keymap.set("n", "<leader>gB", ":Telescope git_branches<CR>", {desc = "Show all branches available to you"})

            -- Git diff commands
            vim.keymap.set("n", "<leader>gd", "<CMD>DiffviewOpen<CR>")
            vim.keymap.set("n", "<leader>gD", "<CMD>DiffviewOpen<CR>")
            vim.keymap.set("n", "<leader>gh", "<CMD>DiffviewFileHistory %<CR>")

        end
    },
    {
        "lewis6991/gitsigns.nvim",
        event = {"BufReadPre", "BufNewFile"},
        opts = {
            signs = {
                add = {text = "+"},
                change = {text = "~"},
                delete = {text = "_"},
                topdelete = {text = "-"},
                changedelete = {text = "~"},
            }
        },
    },
    {
        "FabijanZulj/blame.nvim",
        config = function()
            require("blame").setup{}
            vim.keymap.set("n", "<leader>gb", "<CMD>BlameToggle<CR>")
        end
    }
}
