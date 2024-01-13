local Util = require("lazyvim.util")

local M = {}

M.get_root = Util.root.get

M.separator = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
M.join = function(...)
  return table.concat({ ... }, M.separator)
end

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

M.telescope = function(builtin, opts)
  opts = opts or {}
  return function()
    opts = vim.tbl_deep_extend("force", { cwd = Util.root.get() }, opts)
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end

    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<M-c>", function()
          local action_state = require("telescope.actions.state")
          local line = action_state.get_current_line()
          M.telescope(builtin, vim.tbl_deep_extend("force", opts or {}, { cwd = false, default_text = line }))()
        end)
        return true
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

return M
