return {
  -- split joins
  -- {
  --   "echasnovski/mini.splitjoin",
  --   event = "VeryLazy",
  -- },
  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      mappings = {
        -- Only insert pairs when both adjacent characters are whitespace or line
        -- boundaries. This prevents autopairs while editing next to text, like
        -- `foo|`, `|foo`, or `foo|bar`.
        ["("] = { action = "open", pair = "()", neigh_pattern = "%s%s" },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "%s%s" },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "%s%s" },
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "%s%s", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "%s%s", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "%s%s", register = { cr = false } },
      },
    },
    keys = {
      {
        "<leader>up",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            vim.notify("Disabled auto pairs", vim.log.levels.INFO, { title = "Option" })
          else
            vim.notify("Enabled auto pairs", vim.log.levels.INFO, { title = "Option" })
          end
        end,
        desc = "Toggle auto pairs",
      },
    },
  },

  -- Fast and feature-rich surround actions. For text that includes
  -- surrounding characters like brackets or quotes, this allows you
  -- to select the text inside, change or modify the surrounding characters,
  -- and more.
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },

  -- Comments
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      options = {
        custom_commentstring = function()
          -- ts_context_commentstring's is_treesitter_active() assumes vim.treesitter.get_parser
          -- throws when no parser exists; on current Neovim it returns nil, err instead, so the
          -- plugin crashes on CursorHold for buffers without a treesitter parser (e.g. .env files).
          -- Not fixed upstream yet: https://github.com/JoosepAlviste/nvim-ts-context-commentstring/pull/130
          local ok, commentstring = pcall(function()
            return require("ts_context_commentstring.internal").calculate_commentstring()
          end)
          if ok and commentstring then return commentstring end
          return vim.bo.commentstring
        end,
      },
    },
    init = function()
      local comment_group = vim.api.nvim_create_augroup("commentstring_overrides", { clear = true })
      local overrides = {
        {
          pattern = { "hcl", "terraform" },
          desc = "Terraform/HCL commentstring configuration",
          value = "# %s",
        },
        {
          pattern = { "nix" },
          desc = "Nix commentstring configuration",
          value = "# %s",
        },
      }

      for _, override in ipairs(overrides) do
        vim.api.nvim_create_autocmd("FileType", {
          group = comment_group,
          pattern = override.pattern,
          desc = override.desc,
          callback = function(args) vim.bo[args.buf].commentstring = override.value end,
        })
      end
    end,
    config = true,
  },

  -- Better text-objects
  {
    "echasnovski/mini.ai",
    dependencies = {
      "folke/which-key.nvim",
    },
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      -- https://github.com/LazyVim/LazyVim/blob/78cf0320bfc34050883cde5e7af267184dc60ee9/lua/lazyvim/util/mini.lua#L62
      require("mini.ai").setup(opts)
      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
      }

      local ret = { mode = { "o", "x" } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then desc = desc:gsub(" with ws", "") end
          ret[#ret + 1] = { prefix .. obj[1], desc = desc }
        end
      end
      require("which-key").add(ret, { notify = false })
    end,
  },

  -- Snippets and Autocompletion
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      -- <Tab>/<S-Tab> snippet jumps in insert mode are handled by blink.cmp
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = { "s" } },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "s" } },
    },
  },
  -- Autocompletion
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip", -- snippet engine
      "rafamadriz/friendly-snippets", -- useful snippets
      "fang2hou/blink-copilot", -- copilot source (only enabled when vim.g.ai_cmp is true)
      {
        "saghen/blink.compat", -- reuse nvim-cmp sources (e.g. cmp-emoji)
        version = "2.*",
        lazy = true,
        opts = {},
      },
      "hrsh7th/cmp-emoji", -- source for Emoji
    },
    opts = function()
      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
        Copilot = "",
      }

      local default_sources = { "lsp", "path", "snippets", "buffer" }
      local providers = {
        lsp = { name = "λ", module = "blink.cmp.sources.lsp" },
        path = { name = "", module = "blink.cmp.sources.path" },
        snippets = { name = "⋗", module = "blink.cmp.sources.snippets", min_keyword_length = 2 },
        buffer = { name = "Ω", module = "blink.cmp.sources.buffer", min_keyword_length = 3 },
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      }
      if vim.g.ai_cmp then
        -- copilot suggestions come from the completion menu (fang2hou/blink-copilot)
        table.insert(default_sources, 1, "copilot")
        providers.copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
          opts = { kind_icon = "" }, -- match the Copilot icon used in kind_icons
        }
      end

      return {
        appearance = {
          nerd_font_variant = "mono",
          kind_icons = kind_icons,
        },
        snippets = { preset = "luasnip" },
        completion = {
          accept = { auto_brackets = { enabled = true } },
          menu = { draw = { treesitter = { "lsp" } } },
          documentation = { auto_show = true, auto_show_delay_ms = 200 },
          ghost_text = { enabled = vim.g.ai_cmp },
          list = { selection = { preselect = true, auto_insert = false } },
        },
        signature = { enabled = true },
        cmdline = {
          enabled = true,
          keymap = { preset = "cmdline" },
          completion = {
            list = { selection = { preselect = false } },
            menu = { auto_show = function() return vim.fn.getcmdtype() == ":" end },
          },
        },
        keymap = {
          preset = "enter",
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-j>"] = { function(cmp) return cmp.select_next({ auto_insert = true }) end, "fallback" },
          ["<C-k>"] = { function(cmp) return cmp.select_prev({ auto_insert = true }) end, "fallback" },
          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<S-CR>"] = { "select_and_accept", "fallback" },
          ["<C-CR>"] = { "cancel", "fallback" },
          ["<Tab>"] = {
            "snippet_forward",
            function()
              -- accept copilot ghost text if visible (ghost text mode, ai_cmp = false)
              if not vim.g.ai_cmp then
                local ok, suggestion = pcall(require, "copilot.suggestion")
                if ok and suggestion.is_visible() then
                  suggestion.accept()
                  return true
                end
              end
            end,
            "fallback",
          },
        },
        sources = {
          compat = { "emoji" },
          default = default_sources,
          providers = providers,
          per_filetype = {
            lua = { inherit_defaults = true, "lazydev" },
          },
        },
      }
    end,
    config = function(_, opts)
      -- wire up nvim-cmp sources listed in opts.sources.compat via blink.compat
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end
      -- unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      require("blink.cmp").setup(opts)
    end,
  },

  -- Structural search and replace
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>sR",
        function() require("ssr").open() end,
        mode = { "n", "x" },
        desc = "Structural Replace",
      },
    },
  },

  -- GoLang
  {
    "olexsmir/gopher.nvim",
    lazy = true,
    config = true,
    cmd = {
      "GoTagAdd",
      "GoTagRm",
      "GoMod",
      "GoGet",
      "GoImpl",
      "GoTestAdd",
      "GoTestsAll",
      "GoTestsExp",
      "GoGenerate",
      "GoIfErr",
      "GoCmt",
    },
  },
}
