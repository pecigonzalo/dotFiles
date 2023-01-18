local trouble = require("trouble")

trouble.setup({})

local nmap = function(keys, func, desc)
    if desc then
        desc = ": " .. desc
    end
    vim.keymap.set("n", keys, func, { noremap = true, desc = desc })
end

nmap("<leader>xx", trouble.toggle, "[xx] Trouble Toggle")
nmap("<leader>xw", function()
    trouble.toggle("workspace_diagnostics")
end, "[x] Trouble [w]orkspace")
nmap("<leader>xd", function()
    trouble.toggle("document_diagnostics")
end, "[x] Trouble [d]ocument")
nmap("<leader>xl", function()
    trouble.toggle("loclist")
end, "[x] Trouble [l]oclist")
nmap("<leader>xq", function()
    trouble.toggle("quickfix")
end, "[x] Trouble [q]uickfix")
nmap("gR", function()
    trouble.toggle("lsp_references")
end, "[g]lobal [R]eferences")
