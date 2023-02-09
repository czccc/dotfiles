local M = {}

---@diagnostic disable-next-line: deprecated
_G.table.unpack = table.unpack or unpack

M.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(table.unpack(objects))
end

M.empty_func = function(...) end

M.wrap = function(func, ...)
  local args = { ... }
  return function()
    func(table.unpack(args))
  end
end

M.safe_require = function(mod)
  local ok, module = pcall(require, mod)
  if not ok then
    vim.notify(mod .. " not found!")
    return
  end
  return module
end

M.lazy_require = function(mod, key, ...)
  local args = { ... }
  return function()
    local module = M.safe_require(mod)
    if not module then
      return
    end
    local func = module[key]
    if func == nil then
      vim.notify(mod .. "[" .. key .. "]" .. " not found!")
      return
    end
    func(table.unpack(args))
  end
end

M.separator = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
M.join = function(...)
  return table.concat({ ... }, M.separator)
end

M.keymap = {}
M.keymap.set = function(mode, key, value, opts)
  opts = opts or {}
  if type(opts) == "string" then
    opts = { desc = opts }
  end
  opts.silent = opts.silent or true
  opts.silent = opts.nosilent and false or opts.silent
  vim.keymap.set(mode, key, value, opts)
end
M.keymap.get = function(mode, key)
  vim.keymap.get(mode, key)
end
M.keymap.load = function(opts)
  local key = opts[1]
  local value = opts[2]
  local mode = opts.mode or "n"
  opts[1] = nil
  opts[2] = nil
  opts.mode = nil
  M.keymap.set(mode, key, value, opts)
end
M.keymap.desc_list = {}
M.keymap.desc = function(mode, key, desc)
  if type(mode) == "string" then
    mode = { mode }
  end
  for _, m in ipairs(mode) do
    if not M.keymap.desc_list[m] then
      M.keymap.desc_list[m] = {}
    end
    M.keymap.desc_list[m][key] = desc
  end
end
M.keymap.group_list = {}
M.keymap.group = function(mode, key, desc)
  if type(mode) == "string" then
    mode = { mode }
  end
  for _, m in ipairs(mode) do
    if not M.keymap.group_list[m] then
      M.keymap.group_list[m] = {}
    end
    M.keymap.group_list[m][key] = desc
  end
end

M.cur_word = function()
  local save_previous = vim.fn.getreg("a")
  vim.api.nvim_command('silent! normal! "ayiw')
  local selection = vim.fn.trim(vim.fn.getreg("a"))
  vim.fn.setreg("a", save_previous)
  return vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
end

M.visual_selection = function()
  local save_previous = vim.fn.getreg("a")
  vim.api.nvim_command('silent! normal! "ay')
  local selection = vim.fn.trim(vim.fn.getreg("a"))
  vim.fn.setreg("a", save_previous)
  return vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
M.get_root = function()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- delay notifications till vim.notify was replaced or after 500ms
M.lazy_notify = function()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

return M
