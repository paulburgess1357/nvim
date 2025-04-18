return {
  "echasnovski/mini.files",
  config = function(_, opts)
    require("mini.files").setup(opts)

    -- 🟡 Use warm yellow colors from Kanagawa
    local kanagawa = require("kanagawa.colors").setup()
    local p = kanagawa.palette

    -- Apply highlights
    vim.api.nvim_set_hl(0, "MiniFilesNormal", { fg = p.oldWhite, bg = "#16161D" }) -- File text
    vim.api.nvim_set_hl(0, "MiniFilesDirectory", { fg = p.carpYellow, bold = true }) -- Directories
    vim.api.nvim_set_hl(0, "MiniFilesCursorLine", { bg = p.sumiInk3 }) -- Highlight current line
    vim.api.nvim_set_hl(0, "MiniFilesBorder", { fg = p.autumnYellow, bg = "#16161D" }) -- Border with yellow
  end,
}
