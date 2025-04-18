return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "load-config" }, -- Add dependency on load-config
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- disable the K keymap
    keys[#keys + 1] = { "K", false }
    -- Add gk for documentation (optional)
    keys[#keys + 1] = {
      "gk",
      function()
        vim.lsp.buf.hover()
      end,
      desc = "Show documentation",
    }
    -- Add gl for line diagnostics
    keys[#keys + 1] = {
      "gl",
      function()
        vim.diagnostic.open_float(0, {
          scope = "line",
          border = "rounded",
          focusable = false,
          close_events = { "CursorMoved", "InsertEnter", "BufHidden" },
        })
      end,
      desc = "Show diagnostics for current line",
    }
  end,
  opts = function(_, opts)
    -- Make sure the virtual text setting is applied directly
    opts.diagnostics = opts.diagnostics or {}
    opts.diagnostics.virtual_text = type(_G.VIRTUAL_TEXT_ENABLED) ~= "nil" and _G.VIRTUAL_TEXT_ENABLED or false

    -- Keep the rest of your configuration
    opts.inlay_hints = {
      enabled = false,
    }

    opts.servers = opts.servers or {}
    opts.servers.pyright = {}

    opts.setup = opts.setup or {}
    opts.setup.clangd = function(_, server_opts)
      table.insert(server_opts.cmd, "--limit-results=0")
      return false
    end

    return opts
  end,
}
