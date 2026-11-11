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

-- Our gotmpl injection (nvim/queries/gotmpl/injections.scm) uses `injection.combined`
-- so templated YAML is parsed as one coherent document instead of disjoint fragments.
-- Combined injections can produce byte ranges that fall outside the host buffer, which
-- crashes the treesitter highlighter's decoration provider ("Invalid 'col': out of
-- range") on every redraw. Unresolved upstream as of nvim 0.12:
-- https://github.com/neovim/neovim/issues/29550
-- Re-register the highlighter's decoration provider with each callback wrapped in
-- pcall so these crashes are swallowed instead of spamming the log/UI.
local function silence_combined_injection_highlighter_errors()
  local ts_highlighter = require("vim.treesitter.highlighter")
  local ns = vim.api.nvim_create_namespace("nvim.treesitter.highlighter")

  local function wrap(fn)
    if not fn then return nil end
    return function(...)
      local ok, result = pcall(fn, ...)
      if ok then return result end
    end
  end

  vim.api.nvim_set_decoration_provider(ns, {
    on_win = wrap(ts_highlighter._on_win),
    on_start = wrap(ts_highlighter._on_start),
    on_range = wrap(ts_highlighter._on_range),
    _on_spell_nav = wrap(ts_highlighter._on_spell_nav),
    _on_conceal_line = wrap(ts_highlighter._on_conceal_line),
  })
end

vim.treesitter.language.register("hcl", "terraform-vars")
vim.treesitter.language.register("tsx", { "javascriptreact", "typescriptreact" })
vim.treesitter.query.add_directive("inject-go-tmpl!", function(_, _, bufnr, _, metadata)
  local language = get_gotmpl_host_language(vim.api.nvim_buf_get_name(bufnr))
  if language then metadata["injection.language"] = language end
end, {})
silence_combined_injection_highlighter_errors()

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
