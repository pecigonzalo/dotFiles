vim.opt.showmode = false
vim.opt.cmdheight = 0

local lualine = require("lualine")

lualine.setup({
    options = {
        theme = "dracula-nvim",
        icons_enabled = true,
        component_separators = "|",
        section_separators = "",
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "diff", "diagnostics" },
        lualine_c = {},
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "branch" },
    },
})
