local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local filetype_aliases = {
  js = "javascript",
  jsx = "tsx",
  ts = "typescript",
  tsx = "tsx",
  yml = "yaml",
}

local function get_gotmpl_host_language(path)
  if vim.fn.fnamemodify(path, ":e") == "gotmpl" then path = vim.fn.fnamemodify(path, ":r") end

  local extension = vim.fn.fnamemodify(path, ":e")
  local filetype = filetype_aliases[extension] or vim.filetype.match({ filename = path }) or extension
  return vim.treesitter.language.get_lang(filetype)
end

local function add_gotmpl_injection_directive()
  vim.treesitter.query.add_directive("inject-go-tmpl!", function(_, _, bufnr, _, metadata)
    local language = get_gotmpl_host_language(vim.api.nvim_buf_get_name(bufnr))
    if language then metadata["injection.language"] = language end
  end, {})
end

local function is_templated_yaml(path, bufnr)
  local basename = vim.fs.basename(path)
  if basename == "action.yaml" or basename == "action.yml" then return "yaml" end

  for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)) do
    if line:match("{{.+}}") then return "gotmpl" end
  end

  return "yaml"
end

local function start_treesitter(bufnr)
  local ok = pcall(vim.treesitter.start, bufnr)
  if not ok then return end
end

vim.treesitter.language.register("hcl", "terraform-vars")
vim.treesitter.language.register("tsx", { "javascriptreact", "typescriptreact" })
add_gotmpl_injection_directive()

vim.filetype.add({
  extension = {
    yaml = is_templated_yaml,
    yml = is_templated_yaml,
  },
})

local treesitter_group = augroup("treesitter", { clear = true })
autocmd("FileType", {
  group = treesitter_group,
  callback = function(args) start_treesitter(args.buf) end,
})

vim.keymap.set(
  { "n", "x", "o" },
  "<C-space>",
  function()
    require("flash").treesitter({
      actions = {
        ["<C-space>"] = "next",
        ["<BS>"] = "prev",
      },
    })
  end,
  { desc = "Treesitter incremental selection" }
)
