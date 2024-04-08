return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
            "bash",
            "c",
            "cpp",
            "cmake",
            "dockerfile",
            "go",
            "html",
            "java",
            "javascript",
            "json",
            "latex",
            "lua",
            "python",
            "rust",
            "toml",
            "yaml",
            "zig",
            
        },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
}
