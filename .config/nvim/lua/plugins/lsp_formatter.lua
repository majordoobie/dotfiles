--[[
Lua:
    cargo install stylua

Python:
    pip install black

]] --

return {
    "stevearc/conform.nvim",
    opts = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "black" },
    },
}
