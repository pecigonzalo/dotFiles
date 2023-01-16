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

require('telescope').setup {
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
}

require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')

local nmap = function(keys, func, desc)
  if desc then
    desc = ': ' .. desc
  end
  vim.keymap.set('n', keys, func, { noremap = true, desc = desc })
end

nmap('<leader>?', builtin.oldfiles, '[?] Find recently changed files')
nmap('<leader><space>', builtin.buffers, '[ ] Find existing buffers')
nmap('<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, '[/] Fuzzy current buffer')
nmap('<leader>ff', builtin.find_files, '[f]ind [f]iles')
nmap('<leader>fg', builtin.live_grep, '[f]ind [g]rep')
nmap('<leader>fh', builtin.help_tags, '[f]ind [h]elp tags')
nmap('<leader>fd', builtin.diagnostics, '[f]ind [d]iagnostics')
nmap('<leader>fw', builtin.grep_string, '[f]ind current [s]tring')
