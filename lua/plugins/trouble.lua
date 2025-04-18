return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {
    win = {
      position = "left",
      size = 0.3, -- fallback width: 30% of editor
    },
  },
  keys = {},
  config = function(_, opts)
    local trouble = require("trouble")

    -- List of known modes in Trouble
    local known_modes = {
      "lsp",
      "symbols",
      "lsp_references",
      "lsp_definitions",
      "lsp_type_definitions",
      "lsp_implementations",
      "lsp_declarations",
      "quickfix",
      "loclist",
      "diagnostics",
    }

    -- Set win.position = "left" for all modes
    opts.modes = opts.modes or {}
    for _, name in ipairs(known_modes) do
      opts.modes[name] = opts.modes[name] or {}
      opts.modes[name].win = vim.tbl_deep_extend("force", opts.modes[name].win or {}, {
        position = "left",
      })
    end

    trouble.setup(opts)
  end,
}
