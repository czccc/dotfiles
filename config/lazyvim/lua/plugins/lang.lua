return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { float = { border = "rounded" } },
      servers = {
        pyright = {},
        ruff_lsp = false,
      },
      setup = {
        ruff_lsp = false,
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = { "ga", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" }
      keys[#keys + 1] = { "gl", vim.lsp.codelens.run, desc = "Code Lens", mode = { "n", "v" }, has = "codeLens" }
    end,
  },

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
