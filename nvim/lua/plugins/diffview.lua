local M = {}

M.packer = {
  "sindrets/diffview.nvim",
  opt = true,
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  module = "diffview",
  -- keys = "<leader>gd",
  -- setup = function()
  --   require("which-key").register { ["<leader>gd"] = "diffview: diff HEAD" }
  -- end,
  config = function()
    require("diffview").setup {
      enhanced_diff_hl = true,
      key_bindings = {
        file_panel = { q = "<Cmd>DiffviewClose<CR>" },
        view = { q = "<Cmd>DiffviewClose<CR>" },
        file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
      },
    }
  end,
  disable = false,
}

return M
