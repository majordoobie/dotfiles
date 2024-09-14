-- lets you invoke a terminal with a key binding instead of using tmux to run your code

return {
	"akinsho/toggleterm.nvim",

    config = function()
        require("toggleterm").setup({
            direction = "tab",
            shell = "zsh -l", -- sources zsh hopefully fixing fzf
        })

        vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>", {desc="Open the horizontal terminal"})

    end

}
