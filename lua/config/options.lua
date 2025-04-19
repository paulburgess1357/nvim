-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.autoindent = true
vim.opt.list = false -- show whitespace characters
--vim.opt.winbar = "%=%m %f"
vim.opt.wrap = false

-- Only enable clipboard if xclip is available and DISPLAY is set (X11 session)
if vim.fn.executable("xclip") == 1 and vim.env.DISPLAY then
  vim.opt.clipboard = "unnamedplus"
else
  vim.opt.clipboard = ""
end

-- Winbar colors
require("config.winbar_extend")
