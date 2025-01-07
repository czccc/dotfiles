return {
  -- { "SmiteshP/nvim-navic", opts = { highlight = false, separator = " > " } },
  { "hiphish/rainbow-delimiters.nvim", event = "VeryLazy" },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<C-y>"] = { "select_and_accept" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Esc>"] = { "hide", "fallback" },
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local file_name = vim.bo.buftype == "" and vim.fn.expand("%:.")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = file_name and file_name ~= "" and file_name or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    opts = {
      mappings = {
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\].", register = { cr = false } },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    keys = {
      { "<c-space>", enable = false },
      { "<C-M>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = function(_, opts)
      opts.incremental_selection = vim.tbl_extend("force", opts.incremental_selection or {}, {
        enable = true,
        keymaps = {
          init_selection = "<C-M>",
          node_incremental = "<C-M>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      })
      opts.textobjects = vim.tbl_extend("force", opts.textobjects or {}, {
        lsp_interop = {
          enable = true,
          border = "rounded",
          floating_preview_opts = {},
          peek_definition_code = {
            ["<leader>cp"] = "@function.outer",
            ["<leader>cP"] = "@class.outer",
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { float = { border = "rounded" } },
      servers = {
        pyright = {},
        ruff_lsp = false,
      },
      setup = {
        ruff_lsp = false,
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = { "ga", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" }
      keys[#keys + 1] = { "gl", vim.lsp.codelens.run, desc = "Code Lens", mode = { "n", "v" }, has = "codeLens" }
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "markdownlint",
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
        -- left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        -- middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        persist_buffer_sort = true,
        always_show_bufferline = true,
        sort_by = "insert_after_current",
      },
    },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "BufferLineCycleNext" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "BufferLineCyclePrev" },
      { "<Leader>bC", "<cmd>BufferLinePickClose<cr>", desc = "Buffer Pick Close" },
      { "<Leader>bf", "<cmd>b#<cr>", desc = "Previous" },
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
      -- { "<Leader>ug", "<cmd>Neotree git_status left<cr>", desc = "Git Status" },
      -- { "<Leader>uG", "<cmd>Neotree git_status float<cr>", desc = "Git Status" },
      -- { "<Leader>ub", "<cmd>Neotree buffers left<cr>", desc = "Opened Files" },
      -- { "<Leader>uB", "<cmd>Neotree buffers float<cr>", desc = "Opened Files" },
    },
  },
}
