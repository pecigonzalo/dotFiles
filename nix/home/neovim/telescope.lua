local actions = require("telescope.actions")
local telescope_config = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require('telescope').setup {
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-h>"] = "which_key"
      },
    },
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
}

local builtin = require('telescope.builtin')

local nmap = function(keys, func, desc)
  if desc then
    desc = ': ' .. desc
  end
  vim.keymap.set('n', keys, func, { noremap = true, desc = desc })
end

nmap('<leader>ff', builtin.find_files, '[f]ind [f]iles')
nmap('<leader>fg', builtin.live_grep, '[f]ind [g]rep')
nmap('<leader>fb', builtin.buffers, '[f]ind [b]uffer')
nmap('<leader>fh', builtin.help_tags, '[f]ind [h]elp tags')
nmap('<leader>fs', builtin.current_buffer_fuzzy_find, '[f]ind [s]earch buffer')
nmap('<leader>fd', builtin.diagnostics, '[f]ind [d]iagnostics')
