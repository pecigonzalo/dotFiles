-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }

local cmp = require("cmp")

-- LuaSnip
local luasnip = require("luasnip")
luasnip.config.set_config({
  history = false,   -- Disable return to completion after exit
  update_events = "TextChanged,TextChangedI",
})
require("luasnip.loaders.from_vscode").lazy_load()

local select_opts = { behavior = cmp.SelectBehavior.Select }

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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

-- CMP configuration
cmp.setup({
  completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = function(entry, item)
      item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)       -- This concatonates the icons with the name of the item kind
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(select_opts),
    ["<C-k>"] = cmp.mapping.select_prev_item(select_opts),
    ["<C-j>"] = cmp.mapping.select_next_item(select_opts),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),     -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- Jump to the next placeholder in the snippet.
    ["<C-d>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    -- Jump to the previous placeholder in the snippet.
    ["<C-b>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    -- Autocomplete with tab
    -- If the completion menu is visible, move to the next item
    -- If the line is "empty", insert a Tab character
    -- If the cursor is inside a word, trigger the completion menu
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    -- If the completion menu is visible, move to the previous item
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp_signature_help", priority = 101 },
    { name = "nvim_lsp",                priority = 100 },
    { name = "copilot",                 priority = 99 },
    { name = "luasnip",                 priority = 50, keyword_length = 2, option = { show_autosnippets = true } },
    { name = "path",                    priority = 30 },
    { name = "buffer",                  priority = 10, keyword_length = 3 },
    { name = "emoji",                   priority = 1 },
  }),
})

-- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ "/", "?" }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "buffer" },
--   }),
-- })
--
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "path" },
--     { name = "cmdline" },
--   }),
-- })

--- LSP config
-- Setup lspconfig
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
)

lsp_defaults.lsp_flags = {
  -- Allow using incremental sync for buffer edits
  allow_incremental_sync = true,
  -- Debounce didChange notifications to the server in milliseconds (default=150 in Nvim 0.7+)
  debounce_text_changes = 150,
}

-- Golang
lspconfig.gopls.setup({
  settings = {
    gopls = {
      -- more settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
      analyses = {
        unreachable = true,
        nilness = true,
        unusedparams = true,
        useany = true,
        unusedwrite = true,
        ST1003 = true,
        undeclaredname = true,
        fillreturns = true,
        nonewvars = true,
        fieldalignment = false,
        shadow = true,
        unused = true,
      },
      codelenses = {
        generate = true,           -- show the `go generate` lens.
        gc_details = true,         -- Show a code lens toggling the display of gc's choices.
        test = true,
        tidy = true,
        vendor = true,
        regenerate_cgo = true,
        upgrade_dependency = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      matcher = "Fuzzy",
      diagnosticsDelay = "500ms",
      symbolMatcher = "fuzzy",
      buildFlags = { "-tags", "integration" },
      -- TODO: LSP Complains unusported
      -- hints = {
      --   assignVariableTypes = true,
      --   compositeLiteralFields = true,
      --   compositeLiteralTypes = true,
      --   constantValues = true,
      --   functionTypeParameters = true,
      --   parameterNames = true,
      --   rangeVariableTypes = true,
      -- },
    },
  },
})

-- Terraform
lspconfig.terraformls.setup({})

-- Kotlin
lspconfig.kotlin_language_server.setup({})
-- Java
lspconfig.java_language_server.setup({})

-- Deno
lspconfig.denols.setup({})

-- YAML
lspconfig.yamlls.setup({
  settings = {
    yaml = {
      format = {
        enable = true,
      },
    },
  },
})

-- JSON
lspconfig.jsonls.setup({
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})
-- CSSLS, ESLint, HTML
lspconfig.cssls.setup({})
lspconfig.eslint.setup({})
lspconfig.html.setup({})

-- Nix
lspconfig.rnix.setup({})

-- Python
lspconfig.pyright.setup({})

-- Lua
require("neodev").setup({
  override = function(root_dir, library)
    if root_dir:match("dotFiles") then
      library.enabled = true
      library.plugins = true
    end
  end,
})
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "?.lua")
table.insert(runtime_path, "?/init.lua")
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "hs" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          vim.fn.expand("$VIMRUNTIME/lua"),
          "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
          string.format("%s/.hammerspoon/Spoons/EmmyLua.spoon/annotations", os.getenv("HOME")),
        },
        checkThirdParty = true,
      },
      completion = {
        callSnippet = "Replace",
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Configure LSP bindings
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function()
    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end
      vim.keymap.set("n", keys, func, { buffer = true, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")

    nmap("gd", vim.lsp.buf.definition, "[g]oto [d]efinition")
    nmap("gi", vim.lsp.buf.implementation, "[g]oto [i]mplementation")
    nmap("gr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[d]ocument [s]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove Folder")
    nmap("<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[w]orkspace [l]ist Folders")

    -- Show hints on hold
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = vim.api.nvim_get_current_buf(),
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
      end,
    })
  end,
})

-- Autoformat
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 10000 })
  end,
})
