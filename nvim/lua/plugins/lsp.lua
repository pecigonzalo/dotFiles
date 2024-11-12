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
      -- Autoformat
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ timeout_ms = 10000 })
        end,
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

          nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
          nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")

          nmap("gd", vim.lsp.buf.definition, "Go to Definition")
          nmap("gi", vim.lsp.buf.implementation, "Go to Implementation")
          nmap("gr", require("telescope.builtin").lsp_references, "Go to Refereces")
          nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
          nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

          -- See `:help K` for why this keymap
          nmap("K", vim.lsp.buf.hover, "Hover Documentation")
          nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

          -- Lesser used LSP functionality
          nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
          nmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
          nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
          nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
          nmap("<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List Workspace Folders")

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
    end,
    opts = function()
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")
      if not configs.cluepls then
        configs.cuepls = {
          default_config = {
            cmd = { "cuepls" },
            root_dir = lspconfig.util.root_pattern(".git"),
            filetypes = { "cue" },
          },
        }
      end
      return {
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          cuepls = {},
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
          ansiblels = {},
          bashls = {},
          cssls = {},
          clangd = {},
          denols = {
            root_dir = lspconfig.util.root_pattern("deno.json"),
          },
          ts_ls = {
            -- root_dir = nvim_lsp.util.root_pattern("package.json"),
          },
          dockerls = {},
          eslint = {},
          gleam = {},
          html = {},
          htmx = {},
          java_language_server = {},
          kotlin_language_server = {},
          pyright = {},
          terraformls = {},
          nixd = {},
          -- tailwindcss = {},
          helm_ls = {},
          ruff_lsp = {
            on_attach = function(client, _)
              client.server_capabilities.hoverProvider = false
            end,
          },
        },
        setup = {},
      }
    end,
    config = function(_, opts)
      local configs = require("lspconfig.configs")
      local util = require("lspconfig.util")

      if not configs.helm_ls then
        configs.helm_ls = {
          default_config = {
            cmd = { "helm_ls", "serve" },
            filetypes = { "gotmpl" },
            root_dir = function(fname)
              return util.root_pattern("Chart.yaml")(fname)
            end,
          },
        }
      end

      -- Init servers
      local servers = opts.servers

      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      for server, server_opts in pairs(servers) do
        if server_opts then
          setup(server)
        end
      end
    end,
  },
}
