return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "b0o/schemastore.nvim",
      {
        "folke/neodev.nvim",
        opts = {
          override = function(root_dir, library)
            if root_dir:match("dotFiles") then
              library.enabled = true
              library.plugins = true
            end
          end,
        },
      },
    },
    init = function()
      vim.filetype.add({ extension = { templ = "templ" } })
      local format_group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true })
      local function has_formatter(bufnr)
        local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr })
        if not clients then return false end
        for _, client in ipairs(clients) do
          if client.supports_method and client:supports_method("textDocument/formatting") then return true end
          if client.server_capabilities and client.server_capabilities.documentFormattingProvider then return true end
        end
        return false
      end
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        callback = function(event)
          if not has_formatter(event.buf) then return end
          local ok, err = pcall(function()
            vim.lsp.buf.format({
              bufnr = event.buf,
              async = false,
              timeout_ms = 10000,
            })
          end)
          if not ok then vim.notify(("LSP: format failed (%s)"):format(err), vim.log.levels.WARN) end
        end,
      })

      local hover_group = vim.api.nvim_create_augroup("lsp_hover_diagnostics", { clear = true })
      local function map_buffer_keys(bufnr)
        local function nmap(keys, func, desc)
          if desc then desc = "LSP: " .. desc end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
        nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
        nmap(
          "<leader>wl",
          function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
          "List Workspace Folders"
        )
      end
      local function enable_inlay_hints(client, bufnr)
        if not client or not client.server_capabilities or not client.server_capabilities.inlayHintProvider then
          return
        end
        local ih = vim.lsp.inlay_hint
        local enable = type(ih) == "table" and ih.enable or ih
        if type(enable) == "function" then
          if vim.fn.has("nvim-0.11") == 1 then
            enable(true, { bufnr = bufnr })
          else
            enable(bufnr, true)
          end
        end
      end
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          map_buffer_keys(bufnr)
          enable_inlay_hints(client, bufnr)
          vim.api.nvim_clear_autocmds({ group = hover_group, buffer = bufnr })
          vim.api.nvim_create_autocmd("CursorHold", {
            group = hover_group,
            buffer = bufnr,
            callback = function()
              local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                source = "always",
                prefix = " ",
                scope = "cursor",
              }
              vim.diagnostic.open_float(bufnr, opts)
            end,
          })
        end,
      })
    end,
    opts = function()
      local util = require("lspconfig.util")
      local root_pattern = util.root_pattern
      return {
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          cuepls = {
            cmd = { "cuepls" },
            root_dir = root_pattern(".git"),
            filetypes = { "cue" },
          },
          lua_ls = {
            settings = {
              Lua = {
                format = {
                  enable = false,
                },
                workspace = {
                  ignoreSubmodules = true,
                  checkThirdParty = false,
                  library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$HOME/.hammerspoon/Spoons/EmmyLua.spoon/annotations"),
                  },
                },
                completion = {
                  callSnippet = "Replace",
                },
                diagnostics = { globals = { "hs" } },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                  enable = false,
                },
              },
            },
          },
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
              generate = true, -- show the `go generate` lens.
              gc_details = true, -- Show a code lens toggling the display of gc's choices.
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
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
          templ = {},
          jsonls = {
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          },
          yamlls = {
            settings = {
              yaml = {
                format = { enable = true },
                keyOrdering = false,
                schemaStore = {
                  -- You must disable built-in schemaStore support if you want to use
                  -- this plugin and its advanced options like `ignore`.
                  enable = false,
                  -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                  url = "",
                },
                schemas = require("schemastore").yaml.schemas(),
              },
            },
          },
          cssls = {},
          clangd = {},
          gleam = {},
          html = {},
          htmx = {},
          nixd = {},
          -- tailwindcss = {},
          -- Infra
          bashls = {},
          ansiblels = {},
          helm_ls = {
            filetypes = { "gotmpl" },
            root_dir = root_pattern("Chart.yaml"),
          },
          terraformls = {},
          dockerls = {},
          -- JVM
          java_language_server = {},
          kotlin_language_server = {},
          -- TS
          denols = {
            root_dir = root_pattern("deno.json", "deno.jsonc", "deno.lock"),
            workspace_required = true,
          },
          ts_ls = {
            eslint = {},
            root_dir = root_pattern("tsconfig.json", "package.json", "jsconfig.json"),
            workspace_required = true,
          },
          -- Python
          pyright = {},
          ruff = {
            on_attach = function(client, _) client.server_capabilities.hoverProvider = false end,
          },
        },
        setup = {},
      }
    end,
    config = function(_, opts)
      local servers = opts.servers or {}

      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      capabilities.textDocument = capabilities.textDocument or {}
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      capabilities.workspace = capabilities.workspace or {}
      capabilities.workspace.didChangeWatchedFiles = capabilities.workspace.didChangeWatchedFiles or {}
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      if opts.diagnostics then vim.diagnostic.config(vim.deepcopy(opts.diagnostics)) end

      local setup_handlers = opts.setup or {}

      local function setup(server, server_opts)
        local config = vim.tbl_deep_extend("force", {}, server_opts or {})
        config.capabilities = vim.tbl_deep_extend("force", vim.deepcopy(capabilities), config.capabilities or {})

        local handler = setup_handlers[server] or setup_handlers["*"]
        if handler and handler(server, config) then return end

        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      for server, server_opts in pairs(servers) do
        if server_opts then setup(server, server_opts) end
      end
    end,
  },
}
