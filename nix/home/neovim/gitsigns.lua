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

    -- NOTE: The :Gitsigns calls automatically respects visual select
    map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', '[h]unk [s]tage')
    map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', '[h]unk [r]eset')
    map("n", "ghS", gs.stage_buffer, '[h]unk [S]tage buffer')
    map("n", "<leader>ghu", gs.undo_stage_hunk, '[h]unk [u]ndo stage')
    map('n', '<leader>ghR', gs.reset_buffer, '[h]unk [R]eset buffer')
    map('n', '<leader>ghp', gs.reset_buffer, '[h]unk [p]review')

    map("n", "<leader>ghb", gs.toggle_current_line_blame, '[h] Toggle [b]lame')
    map("n", "<leader>ghd", function() -- Inline diff
      gs.toggle_deleted()
      gs.toggle_linehl()
    end, '[h] Inline [d]iff')
    map("n", "<leader>ghD", gs.diffthis, '[h] Buffer [d]iff') -- Diff in seperate buffer
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
