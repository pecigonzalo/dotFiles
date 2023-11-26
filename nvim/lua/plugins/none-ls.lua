return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "gpanders/editorconfig.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local null_ls = require("null-ls")
    return {
      border = "rounded",
      sources = {
        -- General
        null_ls.builtins.code_actions.refactoring,

        -- Git
        null_ls.builtins.code_actions.gitsigns,

        -- Shell
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.formatting.shfmt,

        -- Go
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.impl,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.diagnostics.golangci_lint,

        -- Kotlin
        null_ls.builtins.diagnostics.ktlint,
        null_ls.builtins.formatting.ktlint,

        -- Python
        null_ls.builtins.diagnostics.mypy,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.formatting.ruff_format,

        -- Typescript
        null_ls.builtins.code_actions.xo,
        null_ls.builtins.diagnostics.xo,
        null_ls.builtins.formatting.prettier,

        -- Lua
        null_ls.builtins.diagnostics.selene,
        null_ls.builtins.formatting.stylua,
      },
    }
  end,
}
