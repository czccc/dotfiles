local M = {}
local path = require "utils.path"
local Log = require "core.log"

M.config = function()
  if path.is_mac then
    gconf.keys.normal_mode["<A-Up>"] = gconf.keys.normal_mode["<C-Up>"]
    gconf.keys.normal_mode["<A-Down>"] = gconf.keys.normal_mode["<C-Down>"]
    gconf.keys.normal_mode["<A-Left>"] = gconf.keys.normal_mode["<C-Left>"]
    gconf.keys.normal_mode["<A-Right>"] = gconf.keys.normal_mode["<C-Right>"]
    Log:debug "Activated mac keymappings"
  end

  if path.is_windows then
    local sqlite_path = path.join(path.home_dir, "PATH", "sqlite3.dll")
    if not path.is_file(sqlite_path) then
      vim.notify "Sqlite dll not found! Download from https://www.sqlite.org/download.html"
    end
    Log:debug("Set sqlite dll path in Windows: " .. sqlite_path)
    vim.g.sqlite_clib_path = sqlite_path
  end
end

return M
