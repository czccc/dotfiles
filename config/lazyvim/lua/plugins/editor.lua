return {
  {
    "nvim-treesitter/nvim-treesitter",
    keys = {
      { "<c-space>", enable = false },
      { "<C-M>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = function(_, opts)
      opts.incremental_selection = vim.tbl_extend("force", opts.incremental_selection or {}, {
        enable = true,
        keymaps = {
          init_selection = "<C-M>",
          node_incremental = "<C-M>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      })
      opts.textobjects = vim.tbl_extend("force", opts.textobjects or {}, {
        lsp_interop = {
          enable = true,
          border = "rounded",
          floating_preview_opts = {},
          peek_definition_code = {
            ["<leader>cp"] = "@function.outer",
            ["<leader>cP"] = "@class.outer",
          },
        },
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    opts = {
      providers = { "lsp", "treesitter", "regex" },
      large_file_overrides = { providers = { "lsp" } },
      filetypes_denylist = { "neo-tree", "TelescopePrompt" },
      modes_denylist = { "v", "x", "vs" },
    },
  },
}
