return {
  "dummy/whitespace",
  dir = ".",
  lazy = false,
  config = function()
    --vim.notify("🔥 Whitespace plugin config loaded")

    ---------------------------------------------------------------------------
    -- Helpers
    ---------------------------------------------------------------------------
    local function remove_trailing_blank_lines()
      local last_line = vim.fn.line("$")
      while last_line > 1 and vim.fn.getline(last_line):match("^%s*$") do
        local second_last_line = vim.fn.getline(last_line - 1)
        if second_last_line:match("^%s*$") then
          vim.api.nvim_buf_set_lines(0, last_line - 1, last_line, false, {})
          last_line = last_line - 1
        else
          break
        end
      end
    end

    local function remove_all_whitespace()
      local view = vim.fn.winsaveview()
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.winrestview(view)
    end

    local function remove_modified_whitespace()
      local gs = require("gitsigns")
      local hunks = gs.get_hunks()
      if not hunks then
        return
      end
      local view = vim.fn.winsaveview()
      for _, hunk in ipairs(hunks) do
        local start_line = hunk.added.start
        local count = hunk.added.count
        if count > 0 then
          local end_line = start_line + count - 1
          vim.cmd(string.format("%d,%ds/\\s\\+$//e", start_line, end_line))
        end
      end
      vim.fn.winrestview(view)
    end

    -- Create a module to expose the toggle functions
    _G.WhitespaceToggles = {
      toggle_autoformat_global = function()
        vim.g.autoformat = not vim.g.autoformat
        vim.notify("Global autoformat: " .. tostring(vim.g.autoformat))
      end,

      toggle_autoformat_buffer = function()
        vim.b.autoformat = not (vim.b.autoformat or vim.g.autoformat)
        vim.notify("Buffer autoformat: " .. tostring(vim.b.autoformat))
      end,

      toggle_clean_mode = function()
        if _G.CLEAN_WHITESPACE_MODE == "all" then
          _G.CLEAN_WHITESPACE_MODE = "modified"
        elseif _G.CLEAN_WHITESPACE_MODE == "modified" then
          _G.CLEAN_WHITESPACE_MODE = "none"
        else
          _G.CLEAN_WHITESPACE_MODE = "all"
        end
        vim.notify("Clean whitespace mode: " .. _G.CLEAN_WHITESPACE_MODE)
      end,

      toggle_trim_blank_lines = function()
        _G.TRIM_TRAILING_BLANK_LINES = not _G.TRIM_TRAILING_BLANK_LINES
        vim.notify("Trim trailing blank lines: " .. tostring(_G.TRIM_TRAILING_BLANK_LINES))
      end,
    }

    ---------------------------------------------------------------------------
    -- Autocommand
    ---------------------------------------------------------------------------
    local function on_save()
      --vim.notify("🔥 on_save triggered with mode: " .. tostring(_G.CLEAN_WHITESPACE_MODE))
      if _G.CLEAN_WHITESPACE_MODE == "all" then
        remove_all_whitespace()
      elseif _G.CLEAN_WHITESPACE_MODE == "modified" then
        remove_modified_whitespace()
      end

      if _G.TRIM_TRAILING_BLANK_LINES then
        remove_trailing_blank_lines()
      end
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = on_save,
    })
  end,
}
