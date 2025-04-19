-- Import colors from the theme
local colors = require("plugins.themes.kanagawa-yellow.non_plugins.winbar_colors")

-- Set up the highlights using imported colors
vim.api.nvim_set_hl(0, "WinBarActive", { fg = colors.active, bold = true })
vim.api.nvim_set_hl(0, "WinBarInactive", { fg = colors.inactive, bold = false })

-- Function to return styled winbar text
local function get_winbar(is_active)
  local hl = is_active and "WinBarActive" or "WinBarInactive"
  return "%=%#" .. hl .. "#%f %m"
end

-- Function to check if current buffer is a mini.files buffer
local function is_mini_files()
  -- Try multiple detection methods for mini.files
  return vim.bo.filetype == "minifiles"
    or vim.b.minifiles ~= nil
    or string.match(vim.bo.filetype or "", "^mini%.files") ~= nil
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
