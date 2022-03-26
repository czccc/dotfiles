local M = {}

M.packer = {
  "folke/trouble.nvim",
  config = function()
    require("trouble").setup {
      auto_open = false,
      auto_close = true,
      padding = false,
      height = 10,
      use_diagnostic_signs = true,
      action_keys = { -- key mappings for actions in the trouble list
        close = { "q", "<esc>" }, -- close the list
        cancel = {}, -- cancel the preview and get back to your last window / buffer / cursor
        jump = "o", -- jump to the diagnostic or open / close folds
        jump_close = { "<cr>" }, -- jump to the diagnostic and close the list
        previous = { "k", "<S-tab>" }, -- preview item
        next = { "j", "<tab>" }, -- next item
      },
    }
  end,
  cmd = "Trouble",
}

return M
