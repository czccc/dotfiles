return {
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    event = "BufReadPost",
    opts = {
      enabled = true,
      bufname_exclude = { "README.md" },
      buftype_exclude = { "terminal", "nofile" },
      filetype_exclude = {
        "alpha",
        "log",
        "gitcommit",
        "UltestSummary",
        "UltestOutput",
        "markdown",
        "txt",
        "vista",
        "NvimTree",
        "git",
        "TelescopePrompt",
        "undotree",
        "help",
        "dashboard",
        "Outline",
        "Trouble",
        "lspinfo",
        "", -- for all buffers without a file type
      },
      char = "▏",
      -- char_list = { "", "┊", "┆", "¦", "|", "¦", "┆", "┊", "" },
      -- char_highlight_list = {
      --   "IndentBlanklineIndent1",
      -- },
      -- show_end_of_line = false,
      show_trailing_blankline_indent = false,
      show_first_indent_level = true,
      space_char_blankline = " ",
      use_treesitter = false,
      show_foldtext = false,
      show_current_context = true,
      show_current_context_start = true,
    },
    init = function()
      vim.g.indent_blankline_char = "▏"
    end,
    cmd = {
      "IndentBlanklineRefresh",
      "IndentBlanklineEnable",
      "IndentBlanklineDisable",
      "IndentBlanklineToggle",
    },
    keys = {
      { "[oi", "<cmd>IndentBlanklineEnable<CR>", desc = "Indent Line" },
      { "]oi", "<cmd>IndentBlanklineDisable<CR>", desc = "Indent Line" },
      { "yoi", "<cmd>IndentBlanklineToggle<CR>", desc = "Indent Line" },
    },
  },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    enabled = false,
    opts = {
      symbol = "▏",
      options = { try_as_border = true },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require("mini.indentscope").setup(opts)
    end,
  },
}
