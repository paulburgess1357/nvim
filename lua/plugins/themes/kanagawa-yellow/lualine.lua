return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local kanagawa = require("kanagawa.colors").setup()
    local palette = kanagawa.palette

    -- Load the base lualine Kanagawa theme
    local theme = require("lualine.themes.kanagawa")

    -- Override section a (mode color) for all modes
    for _, mode in pairs(theme) do
      mode.a.bg = palette.carpYellow
      mode.a.fg = "#16161D" -- match your background
      mode.a.gui = "bold"
    end

    opts.options = opts.options or {}
    opts.options.theme = theme
  end,
}
