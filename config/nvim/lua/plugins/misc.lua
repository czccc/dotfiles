return {
  { "nvim-lua/popup.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "kyazdani42/nvim-web-devicons", lazy = true },
  {
    "karb94/neoscroll.nvim",
    lazy = true,
    event = "BufRead",
    opts = { easing_function = "quadratic" },
  },
  {
    "norcalli/nvim-colorizer.lua",
    lazy = true,
    event = { "BufRead" },
    config = function(spec, opts)
      require("colorizer").setup({ "*" }, { css = true })
    end,
    keys = {
      { "[oC", "<cmd>ColorizerAttachToBuffer<CR>", desc = "Colorizer" },
      { "]oC", "<cmd>ColorizerDetachFromBuffer<CR>", desc = "Colorizer" },
      { "yoC", "<cmd>ColorizerToggle<CR>", desc = "Colorizer" },
    },
  },
  {
    "machakann/vim-sandwich",
    lazy = true,
    event = "BufRead",
    init = function()
      vim.g.sandwich_no_default_key_mappings = 1
      vim.g.operator_sandwich_no_default_key_mappings = 1
      vim.g.textobj_sandwich_no_default_key_mappings = 1
    end,
    keys = {
      { "Sa", "<Plug>(operator-sandwich-add)", mode = "x", desc = "Sandwich Add" },
      { "Sd", "<Plug>(operator-sandwich-delete)", mode = "x", desc = "Sandwich Delete" },
      { "Sr", "<Plug>(operator-sandwich-replace)", mode = "x", desc = "Sandwich Replace" },
    },
  },
  {
    "junegunn/vim-easy-align",
    lazy = true,
    event = "BufRead",
    keys = {
      { "gA", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy Align" },
    },
  },
  -- {
  --   "ojroques/vim-oscyank",
  --   lazy = true,
  --   init = function()
  --     vim.api.nvim_create_autocmd(
  --       { "TextYankPost" },
  --       { command = "if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg \"' | endif" }
  --     )
  --     vim.cmd([[ let g:oscyank_silent = v:true ]])
  --   end,
  -- },
}
