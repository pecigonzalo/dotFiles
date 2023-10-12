return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "gpanders/editorconfig.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    init = function()
        -- Autoformat
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            pattern = "*",
            callback = function()
                vim.lsp.buf.format({ timeout_ms = 10000 })
            end,
        })
    end,
    opts = function()
        local null_ls = require("null-ls")
        return {
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
            },
        }
    end,
}
