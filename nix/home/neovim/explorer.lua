-- Explorer
require("nvim-tree").setup({
    filters = {
        custom = { ".git" },
    },
    hijack_cursor = true,
    open_on_setup = true,
    renderer = {
        icons = {
            glyphs = {
                git = {
                    unstaged = "!",
                    staged = "+",
                    unmerged = "",
                    renamed = "»",
                    untracked = "?",
                    deleted = "✘",
                    ignored = "◌",
                },
            },
        },
    },
})

vim.api.nvim_set_keymap("n", "<C-\\>", ":NvimTreeToggle<CR>", {})

vim.cmd('autocmd BufEnter * ++nested if winnr("$") == 1 && bufname() == "NvimTree_" . tabpagenr() | quit | endif')
