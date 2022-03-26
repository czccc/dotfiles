local M = {}
local Log = require "core.log"

M.packer = {
  "kyazdani42/nvim-tree.lua",
  disable = false,
  config = function()
    require("plugins.nvim_tree").setup()
  end,
}

M.config = function()
  gconf.plugins.nvimtree = {
    setup = {
      disable_netrw = true,
      hijack_netrw = true,
      open_on_setup = false,
      ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
      },
      update_to_buf_dir = {
        enable = true,
        auto_open = true,
      },
      auto_close = true,
      open_on_tab = false,
      hijack_cursor = true,
      update_cwd = true,
      diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },
      system_open = {
        cmd = nil,
        args = {},
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 200,
      },
      actions = {
        change_dir = {
          enable = true,
          global = true,
        },
        open_file = {
          quit_on_open = false,
          resize_window = false,
          window_picker = {
            enable = true,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
      },
      view = {
        width = 30,
        height = 30,
        hide_root_folder = false,
        side = "left",
        auto_resize = false,
        mappings = {
          custom_only = false,
          list = {},
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },
      filters = {
        dotfiles = false,
        custom = { "node_modules", ".cache" },
      },
      trash = {
        cmd = "trash",
        require_confirm = true,
      },
    },
    show_icons = {
      git = 0,
      folders = 1,
      files = 1,
      folder_arrows = 1,
      tree_width = 30,
    },
    -- quit_on_open = 0,
    git_hl = 1,
    highlight_opened_files = 1,
    indent_markers = 1,
    group_empty = 1,
    -- disable_window_picker = 0,
    root_folder_modifier = ":t",
    icons = {
      default = "",
      symlink = "",
      git = {
        unstaged = "",
        staged = "S",
        unmerged = "",
        renamed = "➜",
        deleted = "",
        untracked = "U",
        ignored = "◌",
      },
      folder = {
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
      },
    },
  }

  gconf.plugins.which_key.mappings["e"] = { "<cmd>NvimTreeFocus<CR>", "Explorer" }
  gconf.plugins.which_key.mappings["E"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" }
end

M.setup = function()
  local status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
  if not status_ok then
    Log:error "Failed to load nvim-tree.config"
    return
  end

  for opt, val in pairs(gconf.plugins.nvimtree) do
    vim.g["nvim_tree_" .. opt] = val
  end

  -- Implicitly update nvim-tree when project module is active
  if gconf.plugins.project and gconf.plugins.project.active then
    gconf.plugins.nvimtree.respect_buf_cwd = 1
    gconf.plugins.nvimtree.setup.update_cwd = true
    gconf.plugins.nvimtree.setup.disable_netrw = false
    gconf.plugins.nvimtree.setup.hijack_netrw = false
    vim.g.netrw_banner = false
  end

  -- Add useful keymaps
  local tree_cb = nvim_tree_config.nvim_tree_callback
  if #gconf.plugins.nvimtree.setup.view.mappings.list == 0 then
    local nvim_refresh = function()
      require("nvim-tree.actions.reloaders").reload_git()
      require("nvim-tree.actions.reloaders").reload_explorer()
    end
    gconf.plugins.nvimtree.setup.view.mappings.list = {
      { key = "<Tab>", cb = "<C-w>l" },
      { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
      { key = "h", cb = tree_cb "close_node" },
      { key = "v", cb = tree_cb "vsplit" },
      { key = "R", action = "refresh", action_cb = nvim_refresh },
      { key = "C", cb = tree_cb "cd" },
    }
  end
  require("nvim-tree").setup(gconf.plugins.nvimtree.setup)
end

return M
