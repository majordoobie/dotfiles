-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
        }, true, {})
    vim.fn.getchar()
    os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


-- call our configs before installing plugins
require("config.options")
require("config.keymaps")

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    checker = { -- allows lualine.lua present any neovim data through it
        enabled = true,
        notify = false,
    },

    change_detection = {
        notify = false, -- disable the change notification shit is annoying
    },
})

-- lazy load keymaps
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("config.keymaps")
    end,
})

local function plugin_loaded(plug_name)
    for _, plugin in ipairs(require("lazy").plugins()) do
        if plugin.name == plug_name then
            return true
        end
    end
    return false
end

-- -- Set the theme
-- vim.api.nvim_create_autocmd("User", {
--     pattern = "LazyLoad",
--     callback = function(data)
--         local colorscheme = "oxocarbon"
--         -- local colorscheme = "catppuccin"
--         if data.data == colorscheme then
-- 	        vim.cmd.colorscheme(colorscheme)
--         end
--     end,
-- })

-- Set the theme
-- vim.api.nvim_create_autocmd("User", {
--     pattern = "VeryLazy",
--     callback = function()
--         local colorscheme = "catppuccin"
--         if plugin_loaded(colorscheme) then
--             vim.cmd("colorscheme catppuccin")
-- 	        -- vim.cmd.colorscheme(colorscheme)
--         else
-- 	        vim.notify("Unable to find colorscheme \"" .. colorscheme .. "\"", vim.log.levels.ERROR)
--         end
--     end,
-- })
--

