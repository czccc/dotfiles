local M = {}
-- local Log = require "core.log"

local leader_map = function()
  -- vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  -- vim.api.nvim_set_keymap("n", " ", "", {noremap = true})
  -- vim.api.nvim_set_keymap("x", " ", "", {noremap = true})
end

M.config = function()
  require "core.global"
  require("core.log"):init()
  -- require("core.autocmds").config()
  require("core.pack").init()
  require("plugins").init()

  require("core.osconf").setup()
end

M.setup = function()
  leader_map()
  require("core.options").setup()
  require("core.keymap").setup()

  require("core.autocmds").setup()
  require("core.pack").setup()
  -- require("plugins").setup()
end

M.load_core = function()
  leader_map()
  require "core.global"
  require("core.options").setup()
  require("core.keymap").setup()
  require("core.autocmds").setup()
end

M.load_plugins = function()
  require("core.log"):init()
  require("core.pack").init()
  require("plugins").init()
  require("core.osconf").setup()
  require("core.pack").setup()
  require("core.colors").setup()
end

M.reload = function()
  _G.packer_plugins = _G.packer_plugins or {}
  for k, v in pairs(_G.packer_plugins) do
    if k ~= "packer.nvim" then
      _G.packer_plugins[v] = nil
    end
  end

  require("plugins").reload()
  require("core.osconf").setup()
  require("core.pack").setup()

  vim.notify "Reloaded"
end

return M
