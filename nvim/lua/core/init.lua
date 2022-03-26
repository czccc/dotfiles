local M = {}
local Log = require "core.log"

if vim.fn.has "nvim-0.6.1" ~= 1 then
  vim.notify("Please upgrade your Neovim base installation. Lunarvim requires v0.6.1+", vim.log.levels.WARN)
  vim.wait(5000, function()
    return false
  end)
  vim.cmd "cquit"
end

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
  require("core.options").config()
  require("core.keymap").config()
  require("core.autocmds").config()
  require("core.pack").config()
  require("plugins").config()

  require("core.osconf").config()
end

M.setup = function()
  leader_map()
  require("core.options").setup()
  require("core.keymap").setup()
  require("core.autocmds").setup()
  require("core.pack").setup()
  require("plugins").setup()
end

return M
