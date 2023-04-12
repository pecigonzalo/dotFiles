local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

-- Add additional filetypes for plenary, so syntax highlighting works in Telescope
-- NOTE: add_table is not documented, but its what add_file (documented) calls
require("plenary.filetype").add_table({
  extension = {
    -- extension = filetype
    -- example:
    -- ["jl"] = "julia",
    ["tf"] = "terraform",
  },
  file_name = {
    -- special filenames, likes .bashrc
    -- we provide a decent amount
    -- name = filetype
    -- example:
    -- [".bashrc"] = "bash",
  },
  shebang = {
    -- Shebangs are supported as well. Currently we provide
    -- sh, bash, zsh, python, perl with different prefixes like
    -- /usr/bin, /bin/, /usr/bin/env, /bin/env
    -- shebang = filetype
    -- example:
    -- ["/usr/bin/node"] = "javascript",
  },
})

require("telescope").setup({
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = {
      "rg",
      "--vimgrep",
      "--smart-case",
      "--hidden",
      "--glog",
      "!**/.git/*",
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-h>"] = "which_key",
        ["<c-t>"] = trouble.open_with_trouble,
      },
      n = {
        ["<c-t>"] = trouble.open_with_trouble,
      },
    },
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      -- find_command = { "rg", "--smart-case", "--files", "--hidden", "--glob", "!**/.git/*" },
      find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
    },
  },
})

require("telescope").load_extension("fzf")

local telescope_builtin = require("telescope.builtin")
local telescope_utils = require("telescope.utils")

local nmap = function(keys, func, desc)
  if desc then
    desc = ": " .. desc
  end
  vim.keymap.set("n", keys, func, { noremap = true, desc = desc })
end

-- vim
nmap("<leader>:", telescope_builtin.command_history, "[:] Command history")
nmap("<leader>?", telescope_builtin.oldfiles, "[?] Find recently changed files")
nmap("<leader><space>", telescope_builtin.buffers, "[ ] Find existing buffers")

-- find
nmap("<leader>/", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, "[/] Fuzzy current buffer")
nmap("<leader>ff", telescope_builtin.find_files, "[f]ind [f]iles")
nmap("<leader>fF", function()
  telescope_builtin.find_files({ cwd = telescope_utils.buffer_dir() })
end, "[f]ind [F]iles (cwd)")
nmap("<leader>fg", telescope_builtin.live_grep, "[f]ind [g]rep")
nmap("<leader>fG", function()
  telescope_builtin.live_grep({ cwd = telescope_utils.buffer_dir() })
end, "[f]ind [G]rep (cwd)")
nmap("<leader>fh", telescope_builtin.help_tags, "[f]ind [h]elp tags")
nmap("<leader>fw", telescope_builtin.grep_string, "[f]ind current [s]tring")
nmap("<leader>fW", function()
  telescope_builtin.grep_string({ cwd = telescope_utils.buffer_dir() })
end, "[f]ind current [s]tring (cwd)")
nmap("<leader>fb", telescope_builtin.buffers, "[f]ind current [b]uffers")
nmap("<leader>fr", telescope_builtin.oldfiles, "[f]ind current [r]ecent")

-- git
nmap("<leader>gc", telescope_builtin.git_commits, "[g]it [c]ommits")
nmap("<leader>gs", telescope_builtin.git_status, "[g]it [s]tatus")

-- search
nmap("<leader>sa", telescope_builtin.autocommands, "[s]earch [a]utocommands")
nmap("<leader>sc", telescope_builtin.commands, "[s]earch [c]ommands")
nmap("<leader>sd", function()
  telescope_builtin.diagnostics({ bufnr = 0 })
end, "[s]earch [d]iagnostics")
nmap("<leader>sD", telescope_builtin.diagnostics, "[s]earch [d]iagnostics")
nmap("<leader>sk", telescope_builtin.keymaps, "[s]earch [k]eymaps")
nmap("<leader>sm", telescope_builtin.marks, "[s]earch [m]arks")
