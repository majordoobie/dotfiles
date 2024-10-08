return {
	"nvim-tree/nvim-tree.lua",
    dependencies = {
	    "nvim-lua/plenary.nvim",
	    "nvim-tree/nvim-web-devicons",
	    "MunifTanjim/nui.nvim",
    },
    config = function()
        require("nvim-tree").setup({
            view = {
                width = 30
            },
            actions = {
                open_file = {
                    quit_on_open = false,
                },
            },
        })

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        
        vim.keymap.set("n", "gf", ":NvimTreeToggle<CR>", {desc = "Open up the tree"})
        
    end
}
