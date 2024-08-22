-- harpoon like app
return {
    "fnune/recall.nvim",
    
    config = function()
        local recall = require("recall")
        recall.setup({})

        vim.keymap.set("n", "<leader>ms", recall.toggle, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>ml", recall.goto_next, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>mh", recall.goto_prev, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>mc", recall.clear, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>mm", ":Telescope recall<CR>", { noremap = true, silent = true })

        vim.keymap.set("n", "<leader>m1", "`A");
        vim.keymap.set("n", "<leader>m2", "`B");
        vim.keymap.set("n", "<leader>m3", "`C");
        vim.keymap.set("n", "<leader>m4", "`D");
        vim.keymap.set("n", "<leader>m5", "`E");
    end

}

