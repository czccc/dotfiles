local M = {}

M.packer = {
  "rmagatti/auto-session",
  config = function()
    require("plugins.session").setup()
  end,
  -- after = { "nvim-tree.lua" },
  disable = false,
}

M.setup = function()
  local function close_explorer()
    local status_ok, nvim_tree = pcall(require, "nvim-tree")
    if status_ok then
      pcall(nvim_tree.change_dir, vim.fn.getcwd())
      pcall(nvim_tree.toggle, false, false)
      -- require("nvim-tree.actions.reloaders").reload_explorer()
    end
    local neotree_status_ok, neotree = pcall(require, "neo-tree.command")
    if neotree_status_ok then
      pcall(neotree.execute, { action = "close" })
      -- pcall(vim.cmd [[tabdo Neotree close]])
    end
    pcall(vim.cmd, [[tabdo SymbolsOutlineClose]])
    pcall(vim.cmd, [[tabdo SidebarNvimClose]])
  end
  local function restore_explorer()
    local status_ok, nvim_tree = pcall(require, "nvim-tree")
    if status_ok then
      pcall(nvim_tree.change_dir, vim.fn.getcwd())
      pcall(nvim_tree.toggle, false, false)
      -- require("nvim-tree.actions.reloaders").reload_explorer()
      return
    end
    local neotree_status_ok, neotree = pcall(require, "neo-tree.command")
    if neotree_status_ok then
      pcall(neotree.execute, { action = "close" })
      pcall(neotree.execute, { action = "show" })
      pcall(vim.cmd, vim.api.nvim_replace_termcodes("normal <C-w>=", true, true, true))
      return
    end
  end

  local status_ok, auto_session = pcall(require, "auto-session")
  if not status_ok then
    return
  end

  auto_session.setup {
    log_level = "error",
    auto_session_enable_last_session = false,
    auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
    auto_session_create_enabled = false,
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_suppress_dirs = nil,
    -- the configs below are lua only
    bypass_session_save_file_types = { "Outline", "NvimTree", "neo-tree" },
    pre_save_cmds = { close_explorer },
    post_restore_cmds = { restore_explorer },
  }
end

return M
