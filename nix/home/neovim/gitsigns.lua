require 'gitsigns'.setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local nmap = function(keys, func, desc)
      if desc then
        desc = 'GS: ' .. desc
      end
      vim.keymap.set('n', keys, func, { noremap = true, buffer = bufnr, desc = desc })
    end

    nmap("ml", gs.toggle_current_line_blame, 'Toggle [l]ine Blame')
    nmap("ma", gs.stage_hunk, 'Stage [a]dd Hunk')
    nmap("mA", gs.stage_buffer, 'Stage [A]ll Buffer')
    nmap("mu", gs.undo_stage_hunk, 'Undo Stage Hunk')
    nmap("mD", gs.diffthis, 'Buffer [D]iff') -- Diff in seperate buffer
    nmap("md", function() -- Inline diff
      gs.toggle_deleted()
      gs.toggle_linehl()
    end, 'Inline [d]iff')
  end
}
