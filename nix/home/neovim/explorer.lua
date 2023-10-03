-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Explorer
require("nvim-tree").setup({
  filters = {
    custom = { "^\\.git$" },
  },
  hijack_cursor = true,
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

vim.keymap.set("n", "<C-\\>", function()
  require("nvim-tree.api").tree.toggle()
end)

-- Open NVIM if directory and switch to folder
local function open_nvim_tree(data)
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
