return {
    "Pocco81/true-zen.nvim",
    config = function()
        require("true-zen").setup({})
        vim.keymap.set("n", "<leader>z", ":TZFocus<CR>", {desc="Toggle pane maximization"})
    end
}
