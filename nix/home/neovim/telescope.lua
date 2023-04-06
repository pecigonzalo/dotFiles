local actions = require("telescope.actions")
local telescope_config = require("telescope.config")
local trouble = require("trouble.providers.telescope")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require("telescope").setup({
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
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
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
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
nmap("<leader>sd", telescope_builtin.diagnostics, "[s]earch [d]iagnostics")
nmap("<leader>sk", telescope_builtin.keymaps, "[s]earch [k]eymaps")
nmap("<leader>sm", telescope_builtin.marks, "[s]earch [m]arks")
