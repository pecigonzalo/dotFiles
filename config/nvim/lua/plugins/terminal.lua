return {
  {
    "akinsho/toggleterm.nvim",
    cmd = { "TermExec", "ToggleTerm" },
    keys = {
      { "<C-g>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
    },
    opts = {
      open_mapping = "<C-g>",
      direction = "float",
      shade_terminals = true,
      float_opts = {
        border = "curved",
      },
    },
  },
  {
    "willothy/flatten.nvim",
    branch = "main",
    lazy = false,
    priority = 1001,
    opts = function()
      local saved_terminal
      local cleanup_group = vim.api.nvim_create_augroup("flatten_commit_cleanup", { clear = true })

      local function get_focused_terminal()
        local ok, terminal = pcall(require, "toggleterm.terminal")
        if not ok then return end

        local id = terminal.get_focused_id()
        return id and terminal.get(id) or nil
      end

      local function activate_wezterm_pane()
        if vim.env.WEZTERM_PANE then
          vim.system({ "wezterm", "cli", "activate-pane", "--pane-id", vim.env.WEZTERM_PANE })
        end
      end

      return {
        window = {
          open = "alternate",
        },
        integrations = {
          wezterm = true,
        },
        nest_if_no_args = true,
        hooks = {
          should_block = function(argv) return vim.tbl_contains(argv, "-b") end,
          pre_open = function() saved_terminal = get_focused_terminal() end,
          post_open = function(context)
            if context.is_blocking and saved_terminal then
              saved_terminal:close()
            elseif not context.is_diff then
              activate_wezterm_pane()
            end

            if context.filetype == "gitcommit" or context.filetype == "gitrebase" then
              vim.api.nvim_create_autocmd("BufWritePost", {
                group = cleanup_group,
                buffer = context.bufnr,
                once = true,
                callback = vim.schedule_wrap(function() vim.api.nvim_buf_delete(context.bufnr, {}) end),
              })
            end
          end,
          block_end = function()
            vim.schedule(function()
              if saved_terminal then
                saved_terminal:open()
                saved_terminal = nil
              end
            end)
          end,
        },
      }
    end,
  },
  {
    "numToStr/Navigator.nvim",
    opts = {
      disable_on_zoom = true,
    },
    keys = {
      {
        "<C-w>h",
        function() require("Navigator").left() end,
        desc = "NavigatorLeft",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>l",
        function() require("Navigator").right() end,
        desc = "NavigatorRight",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>k",
        function() require("Navigator").up() end,
        desc = "NavigatorUp",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>j",
        function() require("Navigator").down() end,
        desc = "NavigatorDown",
        silent = true,
        mode = { "n", "t" },
      },
    },
  },
}
