-- lets you invoke a terminal with a key binding instead of using tmux to run your code

return {
	"akinsho/toggleterm.nvim",

    config = function()

        require("toggleterm").setup({
            direction = "horizontal",
        })


        local Terminal  = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({
          cmd = "lazygit",
          dir = "git_dir",
          direction = "float",
          float_opts = {
            border = "double",
          },
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
          end,
          -- function to run on closing the terminal
          on_close = function(term)
            vim.cmd("startinsert!")
          end,
        })

        function _lazygit_toggle()
          lazygit:toggle()
        end


        -- allow the use of <C-q> to change back to "normal" mode
        vim.keymap.set("t", "<C-q>", "<C-\\><C-n>") 

        vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>", {desc="Open terminal within neovim"})
        vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true, desc="Open LazyGit"})
    end

}
