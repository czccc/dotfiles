local utils = require("utils")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
    branch = "v2.x",
    cmd = { "Neotree" },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      default_component_configs = {
        icon = {
          folder_empty = "",
          default = "",
        },
        modified = {
          symbol = "",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "✖", -- this can only be used in the git_status source
            renamed = "", -- this can only be used in the git_status source
            -- Status type
            untracked = "✚", -- ""
            ignored = "",
            unstaged = "",
            staged = "", -- ""
            conflict = "",
          },
        },
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none",
          ["o"] = { "toggle_node", nowait = false },
          ["<Tab>"] = utils.wrap(vim.cmd, "wincmd l"),
          -- ["<2-LeftMouse>"] = "open_with_window_picker",
          -- ["<cr>"] = "open_with_window_picker",
          -- ["S"] = "split_with_window_picker",
          -- ["s"] = "vsplit_with_window_picker",
          -- ["w"] = "open_with_window_picker",
          ["J"] = function(state)
            local tree = state.tree
            local node = tree:get_node()
            local siblings = tree:get_nodes(node:get_parent_id())
            local renderer = require("neo-tree.ui.renderer")
            renderer.focus_node(state, siblings[#siblings]:get_id())
          end,
          ["K"] = function(state)
            local tree = state.tree
            local node = tree:get_node()
            local siblings = tree:get_nodes(node:get_parent_id())
            local renderer = require("neo-tree.ui.renderer")
            renderer.focus_node(state, siblings[1]:get_id())
          end,
        },
      },
      filesystem = {
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
        follow_current_file = true,
        group_empty_dirs = true,
        use_libuv_file_watcher = true,
      },
      git_status = {
        window = { position = "float" },
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
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        enabled = false,
        config = function()
          require("window-picker").setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              bo = {
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                buftype = { "terminal", "quickfix" },
              },
            },
            fg_color = "#151820",
            other_win_hl_color = "#97ca72",
          })
        end,
      },
    },
  },
}
