local M = {}

local utils = require("utils")

M.init = function()
  -- bootstrap lazy.nvim
  local lazypath = utils.join(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

M.setup = function()
  -- lazy setup
  local lazy_opts = {
    defaults = {
      lazy = false, -- should plugins be lazy-loaded?
      version = nil, -- "*" to enable this to try installing the latest stable versions of plugins
    },
    concurrency = 10, ---@type number limit the maximum amount of concurrent tasks
    git = {
      timeout = 120, -- kill processes that take more than 2 minutes
      url_format = "https://github.com/%s.git",
    },
    -- try to load one of these colorschemes when starting an installation during startup
    install = { colorscheme = { "onedark" } },
    ui = { border = "rounded" },
    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = false,
      notify = true, -- get a notification when changes are found
    },
    performance = {
      cache = {
        enabled = true,
        path = vim.fn.stdpath("cache") .. "/lazy/cache",
        -- Once one of the following events triggers, caching will be disabled.
        -- To cache all modules, set this to `{}`, but that is not recommended.
        -- The default is to disable on:
        --  * VimEnter: not useful to cache anything else beyond startup
        --  * BufReadPre: this will be triggered early when opening a file from the command line directly
        disable_events = { "UIEnter", "BufReadPre" },
        ttl = 3600 * 24 * 5, -- keep unused modules for up to 5 days
      },
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "matchit",
          "tar",
          "tarPlugin",
          "rrhelper",
          "spellfile_plugin",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
        },
      },
    },
    -- lazy can generate helptags from the headings in markdown readme files,
    -- so :help works even for plugins that don't have vim docs.
    -- when the readme opens with :help it will be correctly displayed as markdown
    readme = {
      root = vim.fn.stdpath("state") .. "/lazy/readme",
      files = { "README.md", "lua/**/README.md" },
      -- only generate markdown helptags for plugins that dont have docs
      skip_if_doc_exists = true,
    },
  }

  require("lazy").setup({
    { import = "plugins" },
    { import = "plugins.lang" },
  }, lazy_opts)

  utils.keymap.desc("n", "<Leader>p", "Lazy")
  utils.keymap.set("n", "<Leader>pp", "<CMD>Lazy<CR>", "Lazy")
end

return M
