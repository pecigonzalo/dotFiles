return {
  {
    "echasnovski/mini.basics",
    version = "*",
    lazy = false,
    priority = 1000,
    init = function()
      vim.opt.listchars = {
        tab = "→ ",
        eol = "↲",
        trail = "∙",
        extends = "❯",
        precedes = "❮",
      }
    end,
    opts = {
      options = {
        -- Basic options ('termguicolors', 'number', 'ignorecase', and many more)
        basic = true,
        -- Extra UI features ('winblend', 'cmdheight=0', ...)
        extra_ui = true,
        -- Presets for window borders ('single', 'double', ...)
        win_borders = "default",
      },

      -- Mappings. Set to `false` to disable.
      mappings = {
        -- Basic mappings (better 'jk', save with Ctrl+S, ...)
        basic = true,
        -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
        -- Supply empty string to not create these mappings.
        option_toggle_prefix = [[\]],
        -- Window navigation with <C-hjkl>, resize with <C-arrow>
        windows = true,
        -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
        move_with_alt = true,
      },

      -- Autocommands. Set to `false` to disable
      autocommands = {
        -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
        basic = true,

        -- Set 'relativenumber' only in linewise and blockwise Visual mode
        relnum_in_visual_mode = true,
      },
    },
  },
}
