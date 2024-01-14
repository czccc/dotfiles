-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {

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
    "mbbill/undotree",
    init = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
    keys = { { "<Leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" } },
    cmd = { "UndotreeToggle" },
  },
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

  -- add more treesitter parsers
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
  -- {
  --   "echasnovski/mini.surround",
  --   opts = {
  --     mappings = {
  --       add = "gsa",
  --       delete = "gsd",
  --       find = "gsf",
  --       find_left = "gsF",
  --       highlight = "gsh",
  --       replace = "gsr",
  --       update_n_lines = "gsn",
  --     },
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = { "ga", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" }
      keys[#keys + 1] = { "gl", vim.lsp.codelens.run, desc = "Code Lens", mode = { "n", "v" }, has = "codeLens" }
    end,
  },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  {
    "RRethy/vim-illuminate",
    opts = {
      providers = { "lsp", "treesitter", "regex" },
      large_file_overrides = { providers = { "lsp" } },
      filetypes_denylist = { "neo-tree", "TelescopePrompt" },
      modes_denylist = { "v", "x", "vs" },
    },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {
        history = false,
        update_events = "InsertLeave",
        enable_autosnippets = true,
        region_check_events = "CursorHold,InsertLeave",
        delete_check_events = "TextChanged,InsertEnter",
      }
    end,
    config = function()
      require("luasnip/loaders/from_vscode").lazy_load({ paths = { "./snippets" } })
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      ---@diagnostic disable-next-line: unused-function, unused-local
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local feedkey = function(key, mode, replace)
        if replace then
          key = vim.api.nvim_replace_termcodes(key, true, false, true)
          vim.api.nvim_feedkeys(key, mode, false)
        else
          vim.api.nvim_feedkeys(key, mode, true)
        end
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-y>"] = cmp.mapping.complete(),
        ["<Esc>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() then
              cmp.abort()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] = nil
              fallback()
            else
              fallback()
            end
          end,
        }),
        ["<Tab>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            -- elseif has_words_before() then
            --   cmp.complete()
            else
              local next_char = vim.api.nvim_eval("strcharpart(getline('.')[col('.') - 1:], 0, 1)")
              if
                next_char == '"'
                or next_char == "'"
                or next_char == "`"
                or next_char == ")"
                or next_char == "]"
                or next_char == "}"
              then
                feedkey("<Right>", "n", true)
              else
                fallback()
              end
            end
          end,
          s = function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.window = {
        -- completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
      return opts
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "hrsh7th/cmp-cmdline",
  --     "dmitmel/cmp-cmdline-history",
  --   },
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "path" },
  --         { name = "cmdline" },
  --         { name = "cmdline_history", max_item_count = 3, keyword_length = 3 },
  --         { name = "nvim_lua" },
  --       },
  --       formatting = {
  --         format = require("utils.lspkind").cmp_format({}),
  --       },
  --     })
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "buffer" },
  --         { name = "cmdline_history", max_item_count = 3, keyword_length = 3 },
  --       },
  --       formatting = {
  --         format = require("utils.lspkind").cmp_format({}),
  --       },
  --     })
  --     cmp.setup.filetype("markdown", {
  --       sources = cmp.config.sources({
  --         { name = "buffer", max_item_count = 5 },
  --       }),
  --     })
  --
  --     return opts
  --   end,
  -- },
}
