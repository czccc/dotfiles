local M = {}

M.setup = function()
  require("utils.fn").lazy_notify()
  require("core.lazy").init()
  require("core.options")
  require("core.autocmds")
  require("core.keymaps")
  require("core.lazy").setup()
end

return M
