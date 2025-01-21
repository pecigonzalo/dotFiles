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

    local open_with_trouble = function(...) return require("trouble.providers.telescope").open_with_trouble(...) end
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
  end,
}
