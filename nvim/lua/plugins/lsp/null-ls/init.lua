local M = {}

local Log = require "core.log"

function M:setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    Log:error "Missing null-ls dependency"
    return
  end
  gconf.lsp.null_ls.setup.sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.black.with { extra_args = { "--fast" }, filetypes = { "python" } },
    -- null_ls.builtins.formatting.isort.with { extra_args = { "--profile", "black" }, filetypes = { "python" } },

    null_ls.builtins.diagnostics.shellcheck,
    -- null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.vint,
    -- null_ls.builtins.diagnostics.markdownlint.with {
    --   filetypes = { "markdown" },
    -- },

    null_ls.builtins.code_actions.shellcheck,
  }

  local default_opts = require("plugins.lsp").get_common_opts()
  null_ls.setup(vim.tbl_deep_extend("force", default_opts, gconf.lsp.null_ls.setup))
end

return M
