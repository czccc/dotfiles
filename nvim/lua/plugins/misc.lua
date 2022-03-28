local M = {}

M.packers = {
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "Tastyep/structlog.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "mtdl9/vim-log-highlighting", ft = { "text", "log" } },
  { "b0o/schemastore.nvim" },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup { easing_function = "quadratic" }
    end,
    event = "BufRead",
    disable = false,
  },
  {
    "yamatsum/nvim-cursorline",
    opt = true,
    event = "BufWinEnter",
    disable = true,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, { css = true })
    end,
    event = { "BufRead" },
  },
  {
    "gelguy/wilder.nvim",
    -- event = { "CursorHold", "CmdlineEnter" },
    rocks = { "luarocks-fetch-gitrec", "pcre2" },
    requires = { "romgrk/fzy-lua-native" },
    config = function()
      local path = require "utils.path"
      vim.cmd(string.format("source %s", path.join(path.config_dir, "vimscript", "wilder.vim")))
    end,
    run = ":UpdateRemotePlugins",
    disable = false,
  },
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit",
          "gitrebase",
          "svn",
          "hgcommit",
        },
        lastplace_open_folds = true,
      }
    end,
    event = "BufWinEnter",
    disable = false,
  },
}

M.config = function() end

M.setup = function() end

return M
