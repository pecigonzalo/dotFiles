return {
  {
    "akinsho/toggleterm.nvim",
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
    dependencies = {
      {
        "willothy/wezterm.nvim",
        init = function()
          -- TODO: Remove once we upgrade to Neovim 0.10
          vim.system = require("gitsigns.system.compat")
        end,
      },
    },
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1000,
    opts = function()
      ---@type Terminal?
      local saved_terminal

      return {
        window = {
          open = "smart",
        },
        pipe_path = function()
          local flatten = require("flatten")

          -- If running in a terminal inside Neovim:
          local nvim = vim.env.NVIM
          if nvim then
            return nvim
          end

          -- If running in a Wezterm terminal,
          -- all tabs/windows/os-windows in the same instance of wezterm will open in the first neovim instance
          local wezterm = vim.env.WEZTERM_UNIX_SOCKET
          if not wezterm then
            return
          end
          local sock = vim.env.WEZTERM_UNIX_SOCKET:match("gui%-sock%-(%d+)")
          if sock == nil then
            sock = "nopid"
          end
          -- SHA the path to get unique sockets per-dir
          local pwd = vim.fn.sha256(vim.fn.getcwd(-1)):sub(0, 8)

          -- Use TMPDIR as otherwise each neovim instance creates its own directory in neovim
          local temp = vim.env.TMPDIR
          local ret = flatten.try_address(temp .. "nvim.pecigonzalo/" .. "flatten.nvim." .. sock .. "." .. pwd, true)
          if ret ~= nil then
            return ret
          end
        end,
        nest_if_no_args = true,
        one_per = {
          wezterm = true,
        },
        callbacks = {
          should_block = function(argv)
            return vim.tbl_contains(argv, "-b")
          end,
          pre_open = function()
            local term = require("toggleterm.terminal")
            local id = term.get_focused_id()
            saved_terminal = term.get(id)
          end,
          post_open = function(bufnr, winnr, ft, is_blocking, is_diff)
            if is_blocking and saved_terminal then
              -- Hide the terminal while it's blocking
              saved_terminal:close()
            elseif not is_diff then
              -- If it's a normal file, just switch to its window
              vim.api.nvim_set_current_win(winnr)
              -- If it's not in the current wezterm pane, switch to that pane.
              require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")))
            end

            -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
            -- If you just want the toggleable terminal integration, ignore this bit
            if ft == "gitcommit" or ft == "gitrebase" then
              vim.api.nvim_create_autocmd("BufWritePost", {
                buffer = bufnr,
                once = true,
                callback = vim.schedule_wrap(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end),
              })
            end
          end,
          -- After blocking ends (for a git commit, etc), reopen the terminal
          block_end = vim.schedule_wrap(function()
            if saved_terminal then
              saved_terminal:open()
              saved_terminal = nil
            end
          end),
        },
      }
    end,
  },
  {
    "numToStr/Navigator.nvim",
    opts = {
      -- Disable navigation when the current mux pane is zoomed in
      disable_on_zoom = true,
    },
    keys = {
      {
        "<C-w>h",
        function()
          require("Navigator").left()
        end,
        desc = "NavigatorLeft",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>l",
        function()
          require("Navigator").right()
        end,
        desc = "NavigatorRight",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>k",
        function()
          require("Navigator").up()
        end,
        desc = "NavigatorUp",
        silent = true,
        mode = { "n", "t" },
      },
      {
        "<C-w>j",
        function()
          require("Navigator").down()
        end,
        desc = "NavigatorDown",
        silent = true,
        mode = { "n", "t" },
      },
    },
  },
}
