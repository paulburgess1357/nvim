return {
  "snacks.nvim",
  config = function(_, opts)
    -- First setup the dashboard
    require("snacks").setup(opts)

    -- Define custom darker background and new logo color
    -- Using a darker background and a different logo color
    local bg_color = "#16161D" -- Darker background (sumiInk0)
    local logo_color = "#E6C384" -- Logo color (carpYellow)

    -- Then define the highlight groups for the dashboard with new colors
    vim.api.nvim_set_hl(0, "SnacksDashboardNormal", { fg = "#DCD7BA", bg = bg_color })
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = logo_color, bg = bg_color }) -- New logo color
    vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#7E9CD8", bg = bg_color }) -- Wave Blue
    vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#DCA561", bg = bg_color }) -- Roninc Yellow
    vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#E6C384", bg = bg_color }) -- Carp Yellow
    vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#E6C384", bg = bg_color }) -- Carp Yellow
    vim.api.nvim_set_hl(0, "SnacksDashboardDir", { fg = "#76946A", bg = bg_color }) -- Directory paths
    vim.api.nvim_set_hl(0, "SnacksDashboardFile", { fg = "#C8C093", bg = bg_color }) -- File names
    --vim.api.nvim_set_hl(0, "SnacksDashboardKeyDesc", { fg = "#E6C384", bg = bg_color }) -- Warm Yellow
  end,
}
