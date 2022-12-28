local gitsigns = require('gitsigns')

gitsigns.setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local map = function(mode, keys, func, desc)
      if desc then
        desc = ': ' .. desc
      end
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', '[h]unk [s]tage') -- The :Gitsigns calls automatically respects visual select
    map("n", "hS", gs.stage_buffer, '[h]unk [A]ll in buffer')
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', '[h]unk [r]eset') -- The :Gitsigns calls automatically respects visual select
    map('n', '<leader>hR', gs.reset_buffer, '[h]unk [r]eset buffer')
    map("n", "<leader>hu", gs.undo_stage_hunk, '[h]unk undo stage')

    map("n", "<leader>hb", gs.toggle_current_line_blame, '[h] Toggle [b]lame')
    map("n", "<leader>hd", function() -- Inline diff
      gs.toggle_deleted()
      gs.toggle_linehl()
    end, '[h] Inline [d]iff')
    map("n", "<leader>hD", gs.diffthis, '[h] Buffer [d]iff') -- Diff in seperate buffer
    map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select [i]n [h]unk')
  end;

  numhl = true, -- Highlight line numbers for git

  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "▎" },
    topdelete = { text = "契" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },

  preview_config = {
    border = 'rounded',
  },
}
