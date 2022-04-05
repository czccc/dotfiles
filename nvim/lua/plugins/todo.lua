local M = {}

M.packer = {
  "folke/todo-comments.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("plugins.todo").setup()
  end,
  event = "BufRead",
}

M.config = {
  highlight = { max_line_len = 120 },
  colors = {
    error = { "DiagnosticError" },
    warning = { "DiagnosticWarn" },
    info = { "DiagnosticInfo" },
    hint = { "DiagnosticHint" },
    hack = { "Function" },
    ref = { "FloatBorder" },
    default = { "Identifier" },
  },
}

M.setup = function()
  require("todo-comments").setup(M.config)
end

return M
