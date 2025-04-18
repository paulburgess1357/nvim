-- Note: If future bug appears where fzf-lua does not work with ctrl-j and ctrl-k for directions, try removing this file.
-- I have not confirmed, but I briefly had a bug where right after I added this file, the directions did not work.  I'm unsure
-- if its related to this or not.
return {
  "snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,
        header = [[
   ██████   █████                   █████   █████  ███                  
  ░░██████ ░░███                   ░░███   ░░███  ░░░                   
   ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   
   ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  
   ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  
   ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  
   █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ 
  ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  
    ]],
      },
    },
  },
}
