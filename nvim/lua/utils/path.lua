local path = {}
local uv = vim.loop

path.osname = vim.loop.os_uname().sysname
path.is_mac = path.os_name == "Darwin"
path.is_linux = path.os_name == "Linux"
path.is_windows = path.os_name == "Windows_NT"
path.home_dir = path.is_windows and os.getenv "USERPROFILE" or os.getenv "HOME"
path.in_headless = #vim.api.nvim_list_uis() == 0

-- local function get_separator()
--     if path.is_windows then
--         return '\\'
--     end
--     return '/'
-- end

path.separator = vim.loop.os_uname().version:match "Windows" and "\\" or "/"
path.join = function(...)
  return table.concat({ ... }, path.separator)
end

function path.is_file(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "file" or false
end

function path.is_directory(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "directory" or false
end

function path.write_file(path, txt, flag)
  local data = type(txt) == "string" and txt or vim.inspect(txt)
  uv.fs_open(path, flag, 438, function(open_err, fd)
    assert(not open_err, open_err)
    uv.fs_write(fd, data, -1, function(write_err)
      assert(not write_err, write_err)
      uv.fs_close(fd, function(close_err)
        assert(not close_err, close_err)
      end)
    end)
  end)
end

function path.require_clean(module)
  package.loaded[module] = nil
  _G[module] = nil
  local _, requested = pcall(require, module)
  return requested
end

path.runtime_dir = vim.fn.stdpath "data"
path.config_dir = vim.fn.stdpath "config"
path.cache_dir = vim.fn.stdpath "cache"

path.site_dir = path.join(vim.fn.stdpath "data", "site")
path.pack_dir = path.join(path.runtime_dir, "site", "pack")
path.pack_install_dir = path.join(path.runtime_dir, "site", "pack", "packer", "start", "packer.nvim")
path.pack_compile_path = path.join(path.config_dir, "plugin", "packer_compiled.lua")

path.session_dir = path.join(path.runtime_dir, "sessions")
path.dap_install_path = path.join(path.runtime_dir, "dap_install")
path.lsp_install_path = path.join(path.runtime_dir, "lsp_servers")

path.cache_path = vim.fn.stdpath "cache"

local create_dir = function()
  local data_dir = {
    path.join(path.cache_path, "backup"),
    path.join(path.cache_path, "sessions"),
    path.join(path.cache_path, "swap"),
    path.join(path.cache_path, "tags"),
    path.join(path.cache_path, "undo"),
    path.join(path.site_path, "lua"),
  }
  os.execute("mkdir -p " .. path.cache_path)
  for _, v in pairs(data_dir) do
    if vim.fn.isdirectory(v) == 0 then
      os.execute("mkdir -p " .. v)
    end
  end
end

path.create_dir = create_dir

return path
