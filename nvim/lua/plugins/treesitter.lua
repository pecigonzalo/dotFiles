return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      move = {
        enable = true,
        set_jumps = true,
        keys = {
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local function attach(bufnr)
        if not opts.move.enable then return end

        local language = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
        if not language then return end

        local ok, textobjects = pcall(vim.treesitter.query.get, language, "textobjects")
        if not ok or not textobjects then return end

        for method, keymaps in pairs(opts.move.keys) do
          for key, query in pairs(keymaps) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
              if vim.wo.diff and key:find("[cC]") then return vim.cmd("normal! " .. key) end

              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, {
              buffer = bufnr,
              desc = "Treesitter " .. method:gsub("_", " "),
              silent = true,
            })
          end
        end
      end

      local group = vim.api.nvim_create_augroup("treesitter-textobjects", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args) attach(args.buf) end,
      })

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype ~= "" then attach(bufnr) end
      end
    end,
  },
}
