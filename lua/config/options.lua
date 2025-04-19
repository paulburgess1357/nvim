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

-- Kanagawa-like highlights
vim.api.nvim_set_hl(0, "WinBarActive", { fg = "#dca561", bold = true }) -- WaveYellow (bold)
vim.api.nvim_set_hl(0, "WinBarInactive", { fg = "#727169", bold = false }) -- FujiGray

-- Function to return styled winbar text
local function get_winbar(is_active)
  local hl = is_active and "WinBarActive" or "WinBarInactive"
  return "%=%#" .. hl .. "#%f %m"
end

-- Function to check if current buffer is a mini.files buffer
local function is_mini_files()
  local bufname = vim.api.nvim_buf_get_name(0)
  return bufname:match("^minifiles://") ~= nil
end

-- Active window gets vibrant yellow
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    -- Skip mini.files buffers
    if not is_mini_files() then
      vim.wo.winbar = get_winbar(true)
    else
      -- Clear winbar for mini.files
      vim.wo.winbar = ""
    end
  end,
})

-- Inactive window gets subtle gray
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    -- Skip mini.files buffers
    if not is_mini_files() then
      vim.wo.winbar = get_winbar(false)
    end
  end,
})
