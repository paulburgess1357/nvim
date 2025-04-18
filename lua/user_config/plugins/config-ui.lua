return {
  "folke/which-key.nvim",
  optional = true,
  event = "VeryLazy",
  dependencies = { "load-config" }, -- Make sure load-config runs first
  opts = {
    spec = {
      {
        mode = { "n" },
        { "<leader>z", group = "User Config" },
        {
          "<leader>zm",
          function()
            _G.WhitespaceToggles.toggle_clean_mode()
          end,
          desc = function()
            return "Toggle Clean Mode (Current: " .. tostring(_G.CLEAN_WHITESPACE_MODE) .. ")"
          end,
        },
        {
          "<leader>zt",
          function()
            _G.WhitespaceToggles.toggle_trim_blank_lines()
          end,
          desc = function()
            return "Toggle Trim Trailing Blank Lines ("
              .. tostring(_G.TRIM_TRAILING_BLANK_LINES and "on" or "off")
              .. ")"
          end,
        },
        {
          "<leader>zv",
          function()
            _G.DiagnosticToggles.toggle_virtual_text()
          end,
          desc = function()
            local state = type(_G.VIRTUAL_TEXT_ENABLED) ~= "nil" and _G.VIRTUAL_TEXT_ENABLED or false
            return "Toggle Diagnostic Virtual Text (" .. tostring(state and "on" or "off") .. ")"
          end,
        },
      },
    },
  },
}
