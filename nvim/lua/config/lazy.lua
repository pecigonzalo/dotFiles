require("lazy").setup({ { import = "../plugins" } }, {
  defaults = {
    cond = function() return not vim.g.vscode end,
  },
  install = {
    colorscheme = { "dracula" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
})
