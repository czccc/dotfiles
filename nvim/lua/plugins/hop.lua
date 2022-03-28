local M = {}

M.packer = {
  "phaazon/hop.nvim",
  event = "BufRead",
  -- cmd = { "HopChar2", "HopWord" },
  config = function()
    require("plugins.hop").setup()
  end,
  disable = false,
}

M.setup = function()
  require("hop").setup()
  vim.api.nvim_set_keymap(
    "n",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "n",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "o",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "o",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    {}
  )
  gconf.plugins.which_key.mappings["j"] = {
    name = "Hop",
    ["w"] = { "<cmd>HopWord<cr>", "HopWord" },
    ["p"] = { "<cmd>HopPattern<cr>", "HopPattern" },
    ["c"] = { "<cmd>HopChar2<cr>", "HopChar2" },
    ["C"] = { "<cmd>HopChar1<cr>", "HopChar1" },
    ["l"] = { "<cmd>HopLine<cr>", "HopLine" },
    ["L"] = { "<cmd>HopLineStart<cr>", "HopLineStart" },
  }
  vim.cmd [[highlight HopNextKey gui=bold guifg=Orange]]
end

return M
