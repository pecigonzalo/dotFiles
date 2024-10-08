return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPre", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    build = ":TSUpdate",
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts = {
      -- enable syntax highlighting
      highlight = { enable = true },
      -- enable indentation
      indent = { enable = true },
      -- enable context comment string
      context_commentstring = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        "bash",
        "comment",
        "css",
        "cue",
        "dockerfile",
        "fish",
        "gitignore",
        "go",
        "gomod",
        "gotmpl",
        "graphql",
        "gleam",
        "templ",
        "hcl",
        "hjson",
        "html",
        "http",
        "java",
        "javascript",
        "json",
        "json5",
        "jsonnet",
        "kotlin",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "query",
        "regex",
        "rego",
        "rust",
        "sql",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.treesitter.language.register("hcl", "terraform-vars")
    end,
  },
  -- Grammars
  {
    "qvalentin/tree-sitter-go-template",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    build = {
      ":TSInstallFromGrammar gotmpl",
      function()
        -- NOTE: Treesitter checks if files exists, otherwise it does not load the queries
        -- we write an empty file
        local runtime_path = vim.api.nvim_list_runtime_paths()[1]
        local queries_path = runtime_path .. "/after/queries"
        local lang_path = queries_path .. "/" .. "gotmpl"

        if vim.fn.isdirectory(lang_path) == 0 then
          vim.fn.mkdir(lang_path, "p")
        end

        for _, query_name in ipairs({ "injections", "highlights" }) do
          local path = lang_path .. "/" .. query_name .. ".scm"
          local file = io.open(path, "w+")
          if file ~= nil then
            file:write("")
            file:close()
          else
            error("Query file " .. path .. " is nil", 1)
          end
        end
      end,
    },
    init = function()
      vim.filetype.add({
        extension = {
          yaml = function(_, bufnr)
            -- Limit search to only 20 lines
            local content = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false) or ""
            for _, line in ipairs(content) do
              if line:match([[{{.+}}]]) then
                return "gotmpl"
              end
            end
            return "yaml"
          end,
        },
      })
    end,
    config = function()
      local query = require("vim.treesitter.query")

      -- Set the queries
      query.set(
        "gotmpl",
        "injections",
        [[
        ((text) @injection.content
          (#set! injection.language "yaml")
          (#set! injection.combined))
        ]]
      )
      query.set(
        "gotmpl",
        "highlights",
        [[
        ; Identifiers

        [
          (field)
          (field_identifier)
        ] @property

        (variable) @variable

        ; Function calls

        (function_call
          function: (identifier) @function)

        (method_call
          method: (selector_expression
            field: (field_identifier) @method))

        ; Operators

        "|" @operator
        ":=" @operator

        ; Builtin functions

        ((identifier) @function.builtin
          (#match? @function.builtin "^(and|call|html|index|slice|js|len|not|or|print|printf|println|urlquery|eq|ne|lt|ge|gt|ge)$"))

        ; Delimiters

        "." @punctuation.delimiter
        "," @punctuation.delimiter

        "{{" @punctuation.bracket
        "}}" @punctuation.bracket
        "{{-" @punctuation.bracket
        "-}}" @punctuation.bracket
        ")" @punctuation.bracket
        "(" @punctuation.bracket

        ; Keywords

        [
          "else"
          "else if"
          "if"
          "with"
        ] @conditional

        [
          "range"
          "end"
          "template"
          "define"
          "block"
        ] @keyword

        ; Literals

        [
          (interpreted_string_literal)
          (raw_string_literal)
          (rune_literal)
        ] @string

        (escape_sequence) @string.special

        [
          (int_literal)
          (float_literal)
          (imaginary_literal)
        ] @number

        [
          (true)
          (false)
        ] @boolean

        [
          (nil)
        ] @constant.builtin

        (comment) @comment
        (ERROR) @error
        ]]
      )
    end,
  },
  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    enabled = true,
    opts = { mode = "cursor" },
  },
  -- Toggle and configure injections
  -- {
  --   "Dronakurl/injectme.nvim",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  --   -- This is for lazy load and more performance on startup only
  --   cmd = { "InjectmeToggle", "InjectmeSave", "InjectmeInfo", "InjectmeLeave" },
  -- },
}
