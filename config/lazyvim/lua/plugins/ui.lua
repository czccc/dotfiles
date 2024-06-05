return {

  { "folke/trouble.nvim", opts = { use_diagnostic_signs = true } },
  { "neovim/nvim-lspconfig", opts = { diagnostics = { float = { border = "rounded" } } } },
  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "▏",
      draw = { animation = require("mini.indentscope").gen_animation.none() },
    },
  },
  { "lukas-reineke/indent-blankline.nvim", opts = { indent = { char = "▏" } } },
  { "SmiteshP/nvim-navic", opts = { highlight = false, separator = " > " } },

  -- { "hiphish/rainbow-delimiters.nvim", event = "VeryLazy" },
}
