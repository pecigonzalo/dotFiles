{ pkgs, lib, ... }:

let
  mapper = map (x:
    if (x ? plugin) then
      nonVSCodePlugin
        {
          plugin = x.plugin;
          type = if x ? type then x.type else "lua";
          config = x.config;
        }
    else
      nonVSCodePlugin {
        plugin = x;
      }
  );
  nonVSCodePlugin = { plugin, type ? "lua", config ? "" }: {
    plugin = plugin;
    optional = true;
    type = type;
    config = ''
      if not vim.g.vscode then
        vim.cmd('packadd ${plugin.pname}')
        ${config}
      end
    '';
  };
in
{
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        indent_size = 2;
        indent_style = "space";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
      };
      "*.md" = {
        trim_trailing_whitespace = false;
        max_line_length = 80;
      };
      "*.{fs,cs}" = {
        indent_size = 4;
      };
      "*.{csproj,vcxproj,vcxproj.user}" = {
        indent_style = "space";
        indent_size = 2;
      };
      "*.{yml,yaml}" = {
        indent_style = "space";
        indent_size = 2;
      };
      "{Makefile,*.mak}" = {
        indent_style = "tab";
      };
      "*.py" = {
        indent_style = "space";
        indent_size = 4;
        trim_trailing_spaces = true;
      };
    };
  };

  xdg.configFile."nvim/init.lua".text = lib.mkMerge [
    (lib.mkBefore (builtins.readFile ./neovim/init.lua))
    (lib.mkAfter (builtins.readFile ./neovim/final.lua))
  ];

  programs.neovim =
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;

      plugins = with pkgs.vimPlugins; mapper [
        # Theme
        {
          plugin = dracula-nvim;
          config = ''
            vim.cmd [[ colorscheme dracula ]]
          '';
        }

        # Treesitter
        {
          # plugin = nvim-treesitter.withPlugins (_: nvim-treesitter.allGrammars);
          plugin = nvim-treesitter.withPlugins (p: [
            p.bash
            p.comment
            p.cue
            p.dockerfile
            p.fish
            p.go
            p.gomod
            p.graphql
            p.hcl
            p.hjson
            p.html
            p.http
            p.java
            p.javascript
            p.json
            p.json5
            p.jsonnet
            p.kotlin
            p.lua
            p.make
            # p.markdown
            p.nix
            p.python
            p.regex
            p.rego
            p.rust
            p.sql
            p.toml
            p.typescript
            p.yaml
          ]);
          config = builtins.readFile ./neovim/treesitter.lua;
        }
        nvim-treesitter-textobjects
        {
          plugin = nvim-treesitter-context;
          config = ''require("treesitter-context").setup({})'';
        }

        # LSP
        nvim-lspconfig
        cmp-buffer
        cmp-path
        # cmp-cmdline
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-emoji
        luasnip
        friendly-snippets
        cmp_luasnip
        SchemaStore-nvim
        neodev-nvim
        {
          plugin = gopher-nvim;
          config = ''require("gopher").setup({})'';
        }
        {
          plugin = nvim-cmp;
          config = builtins.readFile ./neovim/cmp.lua;
        }

        # Diagnostics
        {
          plugin = trouble-nvim;
          config = builtins.readFile ./neovim/trouble.lua;
        }
        {
          plugin = null-ls-nvim; # Inject LSP diagnostics, code actions, and more via Lua
          config = ''
            local null_ls = require("null-ls")
            null_ls.setup({
              border = "rounded",
              sources = {
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.code_actions.shellcheck,
                null_ls.builtins.diagnostics.shellcheck,

                -- Go
                null_ls.builtins.code_actions.gomodifytags,
                null_ls.builtins.code_actions.impl,
                null_ls.builtins.formatting.goimports,
                null_ls.builtins.diagnostics.golangci_lint,

                -- Kotlin
                null_ls.builtins.diagnostics.ktlint,
                null_ls.builtins.formatting.ktlint,

                -- Python
                null_ls.builtins.diagnostics.flake8,
                null_ls.builtins.diagnostics.mypy,
                null_ls.builtins.diagnostics.pylint,
                null_ls.builtins.diagnostics.selene,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.prettier,

                -- Lua
                null_ls.builtins.formatting.stylua,
              }
            })
          '';
        }

        # Copilot
        {
          # Use lua version
          plugin = copilot-lua;
          config = ''
            require("copilot").setup({
              suggestion = { enabled = false },
              panel = { enabled = false },
            })
          '';
        }
        {
          plugin = copilot-cmp;
          config = ''require("copilot_cmp").setup({})'';
        }

        # Treexplorer
        nvim-web-devicons
        {
          plugin = nvim-tree-lua;
          config = builtins.readFile ./neovim/explorer.lua;
        }

        # Which key
        {
          plugin = which-key-nvim;
          config = ''
            vim.opt.timeoutlen = 500

            require("which-key").setup({
              window = {
                border = 'rounded',
              },
              icons = {
                breadcrumb = '»',
                separator = '->',
                group = '',
              },
            })
          '';
        }

        # Git signals
        {
          plugin = gitsigns-nvim;
          config = builtins.readFile ./neovim/gitsigns.lua;
        }

        # Quick Terminal
        {
          plugin = toggleterm-nvim;
          config = ''
            require("toggleterm").setup({
              open_mapping = '<C-g>',
              direction = 'float',
              shade_terminals = true,
              float_opts = {
                border = 'curved',
              },
            })
          '';
        }

        vim-nix # Nix
        editorconfig-nvim # Editorconfig
        inc-rename-nvim # Incremental rename
        # diffview-nvim # Diff
        {
          plugin = mini-nvim; # Collection of small additions https://github.com/echasnovski/mini.nvim
          config = ''
            require("mini.ai").setup({}) -- Additional text objects, sort of like target.vim
            require("mini.cursorword").setup({}) -- Highlight word under cursor
            -- Minimal and fast autopairs
            require("mini.pairs").setup({
              mappings = {
                ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][^%)]' },
                ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][^%]]' },
                ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][^%}]' },

                ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^%a\\].', register = { cr = false } },
                ["'"] = { action = 'closeopen', pair = "'''", neigh_pattern = '[^%a\\].', register = { cr = false } },
                ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^%a\\].', register = { cr = false } },
              }
            })
            require("mini.surround").setup({}) -- Fast and feature-rich surround plugin
          '';
        }
        {
          plugin = comment-nvim; # Commenting lines
          config = ''require("Comment").setup({})'';
        }

        # UI
        indent-blankline-nvim
        nvim-notify
        nui-nvim
        bufferline-nvim
        lualine-nvim
        dressing-nvim
        {
          plugin = noice-nvim;
          config = builtins.readFile ./neovim/ui.lua;
        }

        # Telescope
        plenary-nvim
        telescope-fzf-native-nvim
        {
          plugin = telescope-nvim;
          config = builtins.readFile ./neovim/telescope.lua;
        }
      ];

      extraPackages = with pkgs; [
        gcc
        tree-sitter

        # Formatters and Linters
        selene
        shfmt
        stylua

        # LSPs
        gopls
        jdt-language-server
        kotlin-language-server
        nodePackages.prettier
        nodePackages.pyright
        nodePackages.vscode-langservers-extracted
        nodePackages.yaml-language-server
        rnix-lsp
        sumneko-lua-language-server
        terraform-ls
      ];
    };
}

