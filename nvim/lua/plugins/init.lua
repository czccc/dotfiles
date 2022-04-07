local M = {}
local Log = require "core.log"

local plugin_files = {
  "plugins.which_key",
  "plugins.misc",
  "plugins.notify",
  "plugins.hop",

  "plugins.themes",

  -- "plugins.nvim_tree",
  "plugins.neotree",
  "plugins.bufferline",
  "plugins.gitsigns",
  "plugins.lualine",
  "plugins.autopairs",

  "plugins.telescope",
  "plugins.treesitter",
  "plugins.trouble",
  "plugins.cmp",
  -- "plugins.copilot",
  "plugins.comment",

  "plugins.tmux",
  "plugins.toggleterm",
  "plugins.async",

  -- "plugins.project",
  "plugins.workspaces",
  "plugins.session",
  "plugins.possession",

  "plugins.lsp",
  "plugins.dap",

  -- "plugins.lsp.lang.clangd_extension",
  -- "plugins.lsp.lang.rust_tools",

  -- "plugins.alpha",
  -- "plugins.bqf",
  "plugins.diffview",
  "plugins.hlslens",
  "plugins.indent_blankline",
  "plugins.lsp_signature",
  "plugins.neoclip",
  "plugins.sidebar",
  "plugins.todo",
  "plugins.zenmode",
}

M.packers = {}

M.init = function()
  M.packers = {}
  for _, plugin_file in ipairs(plugin_files) do
    local status_ok, plugin = pcall(require, plugin_file)
    if not status_ok then
      Log:error("Unable to require file " .. plugin)
      print("Unable to require file " .. plugin)
    end
    if plugin.init then
      pcall(plugin.init)
    end
    if plugin.packer then
      M.packers[#M.packers + 1] = plugin.packer
    end
    if plugin.packers then
      for _, plugin_packer in ipairs(plugin.packers) do
        M.packers[#M.packers + 1] = plugin_packer
      end
    end
  end
end

M.setup = function()
  require("plugins.lsp").setup()
end

M.reload = function()
  M.packers = {}
  for _, plugin_file in ipairs(plugin_files) do
    local status_ok, plugin = pcall(require_clean, plugin_file)
    if not status_ok then
      Log:error("Unable to require file " .. plugin)
      print("Unable to require file " .. plugin)
    end
    if plugin.init then
      pcall(plugin.init)
    end
    if plugin.packer then
      M.packers[#M.packers + 1] = plugin.packer
    end
    if plugin.packers then
      for _, plugin_packer in ipairs(plugin.packers) do
        M.packers[#M.packers + 1] = plugin_packer
      end
    end
  end
end

M.test = {}

function M:register(x)
  self.test[#self.test + 1] = x
end

function M:get()
  return self.test
end

return M
