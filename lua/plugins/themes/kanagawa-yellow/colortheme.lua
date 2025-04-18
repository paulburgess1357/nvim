return {
  {
    "rebelot/kanagawa.nvim",
    opts = {
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Make window borders much more visible
          WinSeparator = { fg = colors.palette.autumnYellow, bold = true },
          -- Visual selection:
          Visual = { bg = colors.palette.carpYellow, fg = colors.palette.sumiInk0 },
          -- Replace purples in UI-like areas with warm yellows
          Keyword = { fg = colors.palette.autumnYellow },
          -- Add popup menu colors
          Pmenu = { fg = colors.palette.fujiWhite, bg = colors.palette.sumiInk2 },
          PmenuSel = { fg = colors.palette.sumiInk0, bg = colors.palette.autumnYellow },
          PmenuSbar = { bg = colors.palette.sumiInk1 },
          PmenuThumb = { bg = colors.palette.autumnYellow },
          -- Explicitly set StatusLine colors to match the theme's dark background
          StatusLine = { bg = "#2A2A37", fg = colors.palette.fujiWhite }, -- Reason for 'black boxes after text'; This is slight blueish to match status bar
          StatusLineNC = { bg = "#16161D", fg = colors.palette.fujiGray },
        }
      end,
    },
  },
}
