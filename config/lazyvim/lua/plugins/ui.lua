return {

  { "folke/trouble.nvim", opts = { use_diagnostic_signs = true } },
  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "▏",
      draw = { animation = require("mini.indentscope").gen_animation.none() },
    },
  },
  { "lukas-reineke/indent-blankline.nvim", opts = { indent = { char = "▏" } } },
  { "SmiteshP/nvim-navic", opts = { highlight = false, separator = " > " } },
  -- { "hiphish/rainbow-delimiters.nvim", event = "VeryLazy" },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
        right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        persist_buffer_sort = true,
        always_show_bufferline = true,
        sort_by = "insert_after_current",
        offsets = {
          {
            filetype = "undotree",
            text = "Undotree",
            highlight = "PanelHeading",
            padding = 1,
          },
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "NeoTreeNormal",
            padding = 1,
            --[[ separator = true, -- use a "true" to enable the default, or set your own character ]]
          },
          {
            filetype = "DiffviewFiles",
            text = "Diff View",
            highlight = "PanelHeading",
            padding = 1,
          },
          {
            filetype = "Outline",
            text = "Symbol Outline",
            highlight = "PanelHeading",
            padding = 1,
          },
          {
            filetype = "neotest-summary",
            text = "Test Summary",
            highlight = "PanelHeading",
            padding = 1,
          },
        },
      },
    },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "BufferLineCycleNext" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "BufferLineCyclePrev" },
      { "<Leader>bC", "<cmd>BufferLinePickClose<cr>", desc = "Buffer Pick Close" },
      { "<Leader>bf", "<cmd>b#<cr>", desc = "Previous" },
      { "<Leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close To Left" },
      { "<Leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close To Right" },
      { "<Leader>bj", "<cmd>BufferLineMovePrev<cr>", desc = "Move To Left" },
      { "<Leader>bk", "<cmd>BufferLineMoveNext<cr>", desc = "Move To Right" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      default_component_configs = {
        modified = {
          symbol = "",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "✖", -- this can only be used in the git_status source
            -- renamed = "", -- this can only be used in the git_status source
            -- Status type
            untracked = "✚", -- ""
            ignored = "",
            -- unstaged = "",
            staged = "", -- ""
            conflict = "",
          },
        },
      },
      window = {
        -- width = 30,
        mappings = {
          ["<space>"] = "none",
          ["o"] = { "toggle_node", nowait = false },
          ["<Tab>"] = function()
            vim.cmd("wincmd l")
          end,
        },
      },
      filesystem = {
        group_empty_dirs = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true, -- only works on Windows for hidden files/directories
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
            ".git",
            --"node_modules"
          },
        },
      },
    },
    keys = {
      { "<Leader>e", "<cmd>Neotree filesystem<cr>", desc = "Explorer" },
      { "<Leader>E", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
      { "<Leader>ug", "<cmd>Neotree git_status left<cr>", desc = "Git Status" },
      { "<Leader>uG", "<cmd>Neotree git_status float<cr>", desc = "Git Status" },
      { "<Leader>ub", "<cmd>Neotree buffers left<cr>", desc = "Opened Files" },
      { "<Leader>uB", "<cmd>Neotree buffers float<cr>", desc = "Opened Files" },
    },
  },
}
