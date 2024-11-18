local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("chungus.plugins", {
 checker = { -- allows lualine.lua present any neovim data through it
    enabled = true,
    notify = true,
  },
  change_detection = {
    notify = false, -- disable the change notification shit is annoying
  },
})
