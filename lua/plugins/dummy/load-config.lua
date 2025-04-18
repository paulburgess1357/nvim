return {
  "dummy/load-config",
  dir = vim.fn.stdpath("config") .. "/lua/plugins/dummy",
  lazy = false,
  priority = 2000, -- High priority to ensure it loads early
  config = function()
    -- Define configuration values directly
    _G.CLEAN_WHITESPACE_MODE = "all"
    _G.TRIM_TRAILING_BLANK_LINES = true
    _G.VIRTUAL_TEXT_ENABLED = false

    -- Apply the diagnostic settings immediately
    vim.diagnostic.config({
      virtual_text = _G.VIRTUAL_TEXT_ENABLED,
    })

    -- Create a toggle function for virtual text
    -- todo should this move into lsp.lua
    if not _G.DiagnosticToggles then
      _G.DiagnosticToggles = {
        toggle_virtual_text = function()
          _G.VIRTUAL_TEXT_ENABLED = not _G.VIRTUAL_TEXT_ENABLED
          vim.diagnostic.config({
            virtual_text = _G.VIRTUAL_TEXT_ENABLED,
          })
          vim.notify(
            "Diagnostic virtual text " .. (_G.VIRTUAL_TEXT_ENABLED and "enabled" or "disabled"),
            vim.log.levels.INFO
          )
        end,
      }
    end
  end,
}
