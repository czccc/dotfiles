local M = {}
local path = require "utils.path"
local Log = require "core.log"

M.setup = function()
  if path.is_windows then
    local sqlite_path = path.join(path.home_dir, "PATH", "sqlite3.dll")
    if not path.is_file(sqlite_path) then
      vim.notify "Sqlite dll not found! Download from https://www.sqlite.org/download.html"
    end
    Log:debug("Set sqlite dll path in Windows: " .. sqlite_path)
    vim.g.sqlite_clib_path = sqlite_path

    local neotree = require "plugins.neotree"
    neotree.config.filesystem.filtered_items.hide_gitignored = false
    neotree.config.filesystem.follow_current_file = false
    neotree.config.filesystem.use_libuv_file_watcher = false
  end
end

return M
