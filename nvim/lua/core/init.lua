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
  -- require("plugins").config()

  require("core.osconf").setup()
end

M.setup = function()
  leader_map()
  require("core.options"):setup()
  require("core.keymap").setup()

  require("core.autocmds").setup()
  require("core.pack").setup()
  -- require("plugins").setup()
end

M.load_core = function ()
  leader_map()
  require "core.global"
  require("core.options").setup()
  require("core.keymap").setup()
  require("core.autocmds").setup()
end

M.load_plugins = function ()
  require("core.log"):init()
  require("core.pack").init()
  require("plugins").init()
  require("core.osconf").setup()
  require("core.pack").setup()
end

return M
