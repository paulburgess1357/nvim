-- File: ~/.config/nvim/lua/plugins/leetcode.lua
return {
  "paulburgess1357/nvim-leetcode",
  branch = "development",
  -- Specify dependencies if needed
  dependencies = {},

  -- Lazy-load the plugin when LC command is used
  cmd = { "LC" },

  -- Configure the plugin
  opts = {
    -- Default language for solutions
    default_language = "cpp",

    -- Cache expiry in days (optional, default is 14)
    cache_expiry_days = 14,

    -- Split ratio for description window (optional, default is 0.35)
    description_split = 0.35,
  },

  -- Additional configuration and key mappings if needed
  config = function(_, opts)
    require("nvim-leetcode").setup(opts)

    -- You could add additional keymaps here if desired
    vim.keymap.set("n", "<leader>ll", "<cmd>LC Pull<cr>", { desc = "LeetCode: Pull problems" })
    vim.keymap.set("n", "<leader>lp", function()
      -- Prompt for a problem number
      vim.ui.input({ prompt = "Problem Number: " }, function(input)
        if input and input:match("^%d+$") then
          vim.cmd("LC " .. input)
        end
      end)
    end, { desc = "LeetCode: Open problem" })
  end,
}
