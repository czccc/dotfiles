local M = require("utils.fn")

-- vim.tbl_deep_extend("force", M, require("utils.fn"))

M.buffer = require("utils.buffer")
M.colors = require("utils.colors")
M.headers = require("utils.headers")
M.icons = require("utils.icons")
M.lsp = require("utils.lsp")
M.telescope = require("utils.telescope")

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M
