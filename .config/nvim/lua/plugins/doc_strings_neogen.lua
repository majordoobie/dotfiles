return { 
    "danymat/neogen", 
    config = function()
        require("neogen").setup({
            vim.keymap.set("n", "<leader>eD", ":Neogen<CR>", {desc="Apply docstring to function"});
        })
    end
}
