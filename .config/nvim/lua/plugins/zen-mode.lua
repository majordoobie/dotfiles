return {
    {
        "shortcuts/no-neck-pain.nvim",
        config = function()
            require("no-neck-pain").setup({
                width = 170,
            })
            vim.keymap.set("n", "Z", ":NoNeckPain<CR>", {desc="Toggle zen mode"})
        end

    },
    -- Zooms a pane to full screen like a debugger window
    {
        "Pocco81/true-zen.nvim",
        config = function()
            require("true-zen").setup({})
            vim.keymap.set("n", "<leader>z", ":TZFocus<CR>", {desc="Toggle pane maximization"})
        end
    },
}
