local utils = require("utils")

return {
  {
    "sindrets/diffview.nvim",
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
      { "<Leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "View File History" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = "BufReadPost",
    opts = {
      signs = {
        add = {
          hl = "GitSignsAdd",
          text = "▎",
          numhl = "GitSignsAddNr",
          linehl = "GitSignsAddLn",
        },
        change = {
          hl = "GitSignsChange",
          text = "▎",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        delete = {
          hl = "GitSignsDelete",
          text = "",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        topdelete = {
          hl = "GitSignsDelete",
          text = "",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "▎",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 200,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      yadm = {
        enable = false,
      },
      on_attach = function()
        local gitsigns = require("gitsigns")
        utils.keymap.set("n", "]g", gitsigns.next_hunk, "Next Git Hunk")
        utils.keymap.set("n", "[g", gitsigns.prev_hunk, "Previous Git Hunk")
      end,
    },
    init = function()
      utils.keymap.group("n", "<Leader>g", "Git")
      utils.keymap.group("n", "yog", "GitSigns")
    end,
    config = function(_, opts)
      local gitsigns = require("gitsigns")
      gitsigns.setup(opts)
    end,
    keys = {
      { "<Leader>gl", utils.lazy_require("gitsigns", "blame_line"), desc = "Blame" },
      { "<Leader>gp", utils.lazy_require("gitsigns", "preview_hunk"), desc = "Preview Hunk" },
      { "<Leader>gr", utils.lazy_require("gitsigns", "reset_hunk"), desc = "Reset Hunk" },
      { "<Leader>gR", utils.lazy_require("gitsigns", "reset_buffer"), desc = "Reset Buffer" },
      { "<Leader>gs", utils.lazy_require("gitsigns", "stage_hunk"), desc = "Stage Hunk" },
      { "<Leader>gS", utils.lazy_require("gitsigns", "stage_buffer"), desc = "Stage Buffer" },
      { "<Leader>gu", utils.lazy_require("gitsigns", "undo_stage_hunk"), desc = "Undo Stage Hunk" },

      -- toggle
      { "yogs", utils.lazy_require("gitsigns", "toggle_signcolumn"), desc = "Toggle Signcolumn" },
      { "yogn", utils.lazy_require("gitsigns", "toggle_numhl"), desc = "Toggle Numhl" },
      { "yogl", utils.lazy_require("gitsigns", "toggle_linehl"), desc = "Toggle Linehl" },
      { "yogw", utils.lazy_require("gitsigns", "toggle_word_diff"), desc = "Toggle Word Diff" },
      { "yogb", utils.lazy_require("gitsigns", "toggle_current_line_blame"), desc = "Toggle Line Blame" },
    },
  },
}
