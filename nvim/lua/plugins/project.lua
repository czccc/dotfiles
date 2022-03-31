local M = {}
local path = require "utils.path"

M.packer = {
  "ahmedkhalf/project.nvim",
  config = function()
    require("plugins.projects").setup()
  end,
  disable = false,
}

function M.config()
  gconf.plugins.project = {
    ---@usage set to true to disable setting the current-woriking directory
    --- Manual mode doesn't automatically change your root directory, so you have
    --- the option to manually do so using `:ProjectRoot` command.
    manual_mode = false,

    ---@usage Methods of detecting the root directory
    --- Allowed values: **"lsp"** uses the native neovim lsp
    --- **"pattern"** uses vim-rooter like glob pattern matching. Here
    --- order matters: if one is not detected, the other is used as fallback. You
    --- can also delete or rearangne the detection methods.
    -- detection_methods = { "lsp", "pattern" }
    -- NOTE: lsp detection will get annoying with multiple langs in one project
    detection_methods = { "pattern" },

    ---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

    ---@ Show hidden files in telescope when searching for files in a project
    show_hidden = false,

    ---@usage When set to false, you will get a message when project.nvim changes your directory.
    -- When set to false, you will get a message when project.nvim changes your directory.
    silent_chdir = true,

    ---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
    ignore_lsp = {},

    ---@type string
    ---@usage path to store the project history for use in telescope
    datapath = path.cache_dir,
  }
end

M.setup = function()
  local project = require "project_nvim"
  project.setup(gconf.plugins.project)
  require("telescope").load_extension "projects"
  gconf.plugins.which_key["s"]["p"] = { ":lua require('plugins.projects').projects()<cr>", "projects" }
end

function M.projects()
  local opts = require("plugins.telescope").dropdown_opts()
  opts.initial_mode = "normal"
  require("telescope").extensions.projects.projects(opts)
end

return M
