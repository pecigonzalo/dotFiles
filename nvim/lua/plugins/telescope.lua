return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.4",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
  },
  config = function()
    require("telescope").load_extension("live_grep_args")
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- Add missing filetype map
    require("plenary.filetype").add_table({
      extension = {
        ["tf"] = "terraform",
      },
    })

    local telescopeConfig = require("telescope.config")

    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, "--hidden")
    -- I don't want to search in the `.git` directory.
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    local open_with_trouble = function(...)
      return require("trouble.providers.telescope").open_with_trouble(...)
    end
    local open_selected_with_trouble = function(...)
      return require("trouble.providers.telescope").open_selected_with_trouble(...)
    end

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["c-t"] = open_with_trouble,
            ["a-t"] = open_selected_with_trouble,
          },
        },
        vimgrep_arguments = vimgrep_arguments,
        file_ignore_patterns = {
          "node_modules/",
          "vendor/",
          ".git/",
        },
      },
      extensions = {
        file_browser = {
          hidden = { file_browser = true, folder_browser = true },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local telescope_builtin = require("telescope.builtin")
    local telescope_utils = require("telescope.utils")

    local nmap = function(keys, func, desc)
      if desc then
        desc = desc
      end
      vim.keymap.set("n", keys, func, { noremap = true, desc = desc })
    end

    -- vim
    nmap("<leader>:", telescope_builtin.command_history, "Command history")
    nmap("<leader>?", telescope_builtin.oldfiles, "Find Recently Changed Files")
    nmap("<leader><space>", telescope_builtin.buffers, "Find Existing Buffers")

    -- find
    nmap("<leader>/", function()
      require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, "Fuzzy Current Buffer")
    nmap("<leader>ff", telescope_builtin.find_files, "Find Files")
    nmap("<leader>fF", function()
      telescope_builtin.find_files({ cwd = telescope_utils.buffer_dir() })
    end, "Find Files (cwd)")
    -- nmap("<leader>fg", telescope_builtin.live_grep, "Find Grep")
    nmap("<leader>fg", function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end, "Find Grep")
    nmap("<leader>fG", function()
      telescope_builtin.live_grep({ cwd = telescope_utils.buffer_dir() })
    end, "Find Grep (cwd)")
    nmap("<leader>fh", telescope_builtin.help_tags, "Find Help Tags")
    nmap("<leader>fw", telescope_builtin.grep_string, "Find Current String")
    nmap("<leader>fW", function()
      telescope_builtin.grep_string({ cwd = telescope_utils.buffer_dir() })
    end, "Find Current String (cwd)")
    nmap("<leader>fr", telescope_builtin.oldfiles, "Find Current Recent")

    -- git
    nmap("<leader>gc", telescope_builtin.git_commits, "Git Commits")
    nmap("<leader>gs", telescope_builtin.git_status, "Git Status")

    -- search
    nmap("<leader>sa", telescope_builtin.autocommands, "Search Autocommands")
    nmap("<leader>sc", telescope_builtin.commands, "Search Commands")
    nmap("<leader>sd", function()
      telescope_builtin.diagnostics({ bufnr = 0 })
    end, "Search Diagnostics")
    nmap("<leader>sD", telescope_builtin.diagnostics, "Search Diagnostics")
    nmap("<leader>sk", telescope_builtin.keymaps, "Search Keymaps")
    nmap("<leader>sm", telescope_builtin.marks, "Search Marks")
  end,
}
