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
          plugin = nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
          config = builtins.readFile ./neovim/treesitter.lua;
        }
        nvim-treesitter-textobjects

        # LSP
        nvim-lspconfig
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp-nvim-lsp
        luasnip
        friendly-snippets
        cmp_luasnip
        SchemaStore-nvim
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
              sources = {
                null_ls.builtins.code_actions.shellcheck,
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.completion.luasnip,
                null_ls.builtins.diagnostics.flake8,
                null_ls.builtins.diagnostics.ktlint,
                null_ls.builtins.diagnostics.mypy,
                null_ls.builtins.diagnostics.shellcheck,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.ktlint,
              }
            })
          '';
        }

        # Treexplorer
        nvim-web-devicons
        {
          plugin = nvim-tree-lua;
          config = builtins.readFile ./neovim/explorer.lua;
        }

        # Telescope
        plenary-nvim
        {
          plugin = telescope-nvim;
          config = builtins.readFile ./neovim/telescope.lua;
        }
        {
          plugin = telescope-fzf-native-nvim;
          config = ''require('telescope').load_extension('fzf')'';
        }

        # Which key
        {
          plugin = which-key-nvim;
          config = ''
            vim.opt.timeoutlen = 500

            require('which-key').setup {
              window = {
                border = 'rounded',
              },
              icons = {
                breadcrumb = '»',
                separator = '->',
                group = '',
              },
            }
          '';
        }

        # Git signals
        {
          plugin = gitsigns-nvim;
          config = builtins.readFile ./neovim/gitsigns.lua;
        }

        # Color indentation
        {
          plugin = indent-blankline-nvim;
          config = ''
            -- Display characters
            vim.opt.list = true
            vim.opt.listchars = {
              tab = "→ ",
              eol = "↲",
              trail = "∙",
              extends = "❯",
              precedes = "❮",
            }

            require('indent_blankline').setup {
              char = "▏",
              context_char = "▎",
              filetype_exclude = {
                "lspinfo",
                "packer",
                "checkhealth",
                "help",
                "man",
                "dashboard",
                "NvimTree",
                "text",
              },

              use_treesitter = true,

              show_trailing_blankline_indent = false,
              show_first_indent_level = false,

              show_current_context = true,
              show_current_context_start = true,

              space_char_blankline = " ",
            }
          '';
        }

        # Quick Terminal
        {
          plugin = toggleterm-nvim;
          config = ''
            require('toggleterm').setup({
              open_mapping = '<C-g>',
              direction = 'float',
              shade_terminals = true,
              float_opts = {
                border = 'curved',
              },
            })
          '';
        }

        # Bufferline
        {
          plugin = bufferline-nvim;
          config = ''
            require('bufferline').setup({
              options = {
                mode = 'buffers',
                offsets = {
                  {filetype = 'NvimTree'}
                },
              },
              highlights = {
                buffer_selected = {
                  italic = false
                },
                indicator_selected = {
                  fg = {attribute = 'fg', highlight = 'Function'},
                  italic = false
                }
              }
            })
          '';
        }
        lualine-lsp-progress
        {
          plugin = lualine-nvim;
          config = builtins.readFile ./neovim/lualine.lua;
        }

        # Additinal motion helpers
        {
          plugin = nvim-surround;
          config = ''require("nvim-surround").setup({})'';
        }

        vim-visual-multi # Multiple cursors
        vim-nix # Nix
        editorconfig-nvim # Editorconfig
        {
          plugin = comment-nvim; # Commenting lines
          config = ''require('Comment').setup({})'';
        }
      ];

      extraPackages = with pkgs; [
        gcc
        tree-sitter

        # LSPs
        gopls
        shfmt
        rnix-lsp
        terraform-ls
        kotlin-language-server
        sumneko-lua-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.pyright
      ];
    };
}
