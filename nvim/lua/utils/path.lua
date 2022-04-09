local Path = {}
local uv = vim.loop

Path.os_name = vim.loop.os_uname().sysname
Path.is_mac = Path.os_name == "Darwin"
Path.is_linux = Path.os_name == "Linux"
Path.is_windows = Path.os_name == "Windows_NT"
Path.is_wsl = Path.is_linux and vim.fn.has "wsl" ~= 0
Path.home_dir = Path.is_windows and os.getenv "USERPROFILE" or os.getenv "HOME"
Path.in_headless = #vim.api.nvim_list_uis() == 0

-- local function get_separator()
--     if path.is_windows then
--         return '\\'
--     end
--     return '/'
-- end

Path.separator = vim.loop.os_uname().version:match "Windows" and "\\" or "/"
Path.join = function(...)
  return table.concat({ ... }, Path.separator)
end

function Path.is_file(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "file" or false
end

function Path.is_directory(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "directory" or false
end

function Path.write_file(path, txt, flag)
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

function Path.require_clean(module)
  package.loaded[module] = nil
  _G[module] = nil
  local _, requested = pcall(require, module)
  return requested
end

Path.runtime_dir = vim.fn.stdpath "data"
Path.config_dir = vim.fn.stdpath "config"
Path.cache_dir = vim.fn.stdpath "cache"

Path.site_dir = Path.join(vim.fn.stdpath "data", "site")
Path.pack_dir = Path.join(Path.runtime_dir, "site", "pack")
Path.pack_install_dir = Path.join(Path.runtime_dir, "site", "pack", "packer", "start", "packer.nvim")
Path.pack_compile_path = Path.join(Path.config_dir, "plugin", "packer_compiled.lua")

Path.session_dir = Path.join(Path.runtime_dir, "sessions")
Path.dap_install_path = Path.join(Path.runtime_dir, "dap_install")
Path.lsp_install_path = Path.join(Path.runtime_dir, "lsp_servers")

Path.cache_path = vim.fn.stdpath "cache"

local create_dir = function()
  local data_dir = {
    Path.join(Path.cache_path, "backup"),
    Path.join(Path.cache_path, "sessions"),
    Path.join(Path.cache_path, "swap"),
    Path.join(Path.cache_path, "tags"),
    Path.join(Path.cache_path, "undo"),
    Path.join(Path.site_path, "lua"),
  }
  os.execute("mkdir -p " .. Path.cache_path)
  for _, v in pairs(data_dir) do
    if vim.fn.isdirectory(v) == 0 then
      os.execute("mkdir -p " .. v)
    end
  end
end

Path.create_dir = create_dir

return Path
