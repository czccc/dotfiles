local utils = require("utils")

return {
  {
    "folke/which-key.nvim",
    lazy = true,
    event = { "VeryLazy" },
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ...
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
        spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
      },
      operators = { gc = "Comments", c = "Change", ['"-c'] = "Change" },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
    },
    config = function(spec, opts)
      local wk = require("which-key")
      wk.setup(opts)

      for mode, group_list in pairs(utils.keymap.group_list) do
        for key, desc in pairs(group_list) do
          local tmp = {}
          tmp[key] = { name = desc }
          wk.register(tmp, { mode = mode })
        end
      end

      for mode, desc_list in pairs(utils.keymap.desc_list) do
        for key, desc in pairs(desc_list) do
          local tmp = {}
          tmp[key] = { desc }
          wk.register(tmp, { mode = mode })
        end
      end
    end,
  },
}
