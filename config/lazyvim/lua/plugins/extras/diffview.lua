return {
  {
    "sindrets/diffview.nvim",
    -- enabled = false,
    lazy = true,
    opts = {
      enhanced_diff_hl = true,
      key_bindings = {
        file_panel = { q = "<Cmd>DiffviewClose<CR>" },
        view = { q = "<Cmd>DiffviewClose<CR>" },
        file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
      },
    },
    keys = {
      { "<Leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff HEAD" },
      { "<Leader>gD", "<cmd>DiffviewOpen -uno -- %<cr>", desc = "Diff Current File" },
      { "<Leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "View File History" },
    },
  },
}
