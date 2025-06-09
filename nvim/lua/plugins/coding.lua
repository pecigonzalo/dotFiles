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
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][%s]" },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][%s]" },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][%s]" },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\][%s]" },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\][%s]" },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\][%s]" },

        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\][%s]", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\][%s]", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\][%s]", register = { cr = false } },
      },
    },
    keys = {
      {
        "<leader>up",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            vim.notify("Disabled auto pairs", "info", { title = "Option" })
          else
            vim.notify("Enabled auto pairs", "info", { title = "Option" })
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
    keys = {
      { "gsa", desc = "Add surrounding", mode = { "n", "v" } },
      { "gsd", desc = "Delete surrounding" },
      { "gsf", desc = "Find right surrounding" },
      { "gsF", desc = "Find left surrounding" },
      { "gsh", desc = "Highlight surrounding" },
      { "gsr", desc = "Replace surrounding" },
      { "gsn", desc = "Update `MiniSurround.config.n_lines`" },
    },
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
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    init = function() vim.g.skip_ts_context_commentstring_module = true end,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "hcl", "terraform" },
        desc = "Terraform/HCL commentstring configuration",
        command = "setlocal commentstring=#\\ %s",
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "nix" },
        desc = "Nix commentstring configuration",
        command = "setlocal commentstring=#\\ %s",
      })
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
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
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
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
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
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      "hrsh7th/cmp-cmdline", -- source for cmdline
      "hrsh7th/cmp-nvim-lsp", -- source for LSP
      "hrsh7th/cmp-nvim-lsp-signature-help", -- source for signatures from LSP
      "b0o/schemastore.nvim", -- source for JSON schemas
      "hrsh7th/cmp-emoji", -- source for Emoji
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()

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

      local menu_icon = {
        nvim_lsp_signature_help = "󰇽",
        nvim_lsp = "λ",
        luasnip = "⋗",
        buffer = "Ω",
        path = "",
        copilot = "",
      }

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions

          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<C-e>"] = cmp.mapping.abort(), -- close completion window

          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          -- Group 1
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "luasnip", keyword_lenght = 2, options = { show_autosnippets = true } }, -- snippets
          { name = "path" }, -- file system paths
          { name = "copilot" }, -- Github Copilot
        }, {
          -- Group 2
          { name = "emoji" },
          { name = "buffer", keyword_lenght = 3 }, -- text within current buffer
        }),
        formatting = {
          format = function(entry, item)
            item.kind = string.format("%s %s", kind_icons[item.kind], item.kind) -- This concatonates the icons with the name of the item kind
            item.menu = menu_icon[entry.source.name]
            return item
          end,
        },
        sorting = defaults.sorting,
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "buffer" },
        }),
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
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
