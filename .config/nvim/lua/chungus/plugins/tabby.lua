-- allows for nicer tabs like automatically naming the tabs by the file name
return {
	"nanozuki/tabby.nvim",
    
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },

    config = function()
        require("tabby").setup({
            preset = "float",
        })

    end
}
