return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        ruff_lsp = false,
      },
      setup = {
        ruff_lsp = false,
      },
    },
  },

  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     opts.sources = opts.sources or {}
  --     vim.list_extend(opts.sources, {
  --       nls.builtins.diagnostics.flake8,
  --     })
  --   end,
  -- },
}
