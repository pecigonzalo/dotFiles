return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Workspace/", "~/Downloads", "~/Documents", "~/Desktop/", "/" },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
    keymap.set("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
  end,
}
