local M = {}

M.packer = {
  "folke/todo-comments.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("plugins.todo").setup()
  end,
  event = "BufRead",
}

M.setup = function()
  local status_ok, todo = pcall(require, "todo-comments")
  if not status_ok then
    return
  end

  todo.setup {
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
end

return M
