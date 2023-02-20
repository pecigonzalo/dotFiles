-- Explorer
require("nvim-tree").setup({
  filters = {
    custom = { ".git" },
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

vim.api.nvim_set_keymap("n", "<C-\\>", ":NvimTreeToggle<CR>", {})

-- Open NVIM if directory and switch to folder
local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
