local M = {}

function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local path_sep = vim.loop.os_uname().version:match "Windows" and "\\" or "/"
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

function _G.require_clean(module)
  package.loaded[module] = nil
  _G[module] = nil
  local _, requested = pcall(require, module)
  return requested
end

M.conf = {}

return M
