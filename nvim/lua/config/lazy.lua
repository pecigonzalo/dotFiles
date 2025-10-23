local vscodeEnabledPlugins = {
  "which-key.nvim",
  "mini.basics",
  "mini.ai",
  "mini.comment",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "snacks.nvim",
  "ts-comments.nvim",
  "flash.nvim",
}

require("lazy").setup({ { import = "plugins" } }, {
  defaults = {
    cond = function(plugin)
      if not vim.g.vscode then
        return true
      elseif vim.g.vscode and vim.tbl_contains(vscodeEnabledPlugins, plugin.name) then
        return true
      else
        return false
      end
    end,
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
