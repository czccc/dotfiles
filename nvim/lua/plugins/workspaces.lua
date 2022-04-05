local M = {}
local path = require "utils.path"

M.packers = {
  {
    "natecraddock/workspaces.nvim",
    config = function()
      require("plugins.workspaces").setup_workspaces()
    end,
  },
  {
    "natecraddock/sessions.nvim",
    config = function()
      require("plugins.workspaces").setup_sessions()
    end,
  },
}

M.config_workspace = {
  -- path to a file to store workspaces data in
  -- on a unix system this would be ~/.local/share/nvim/workspaces
  path = path.join(vim.fn.stdpath "data", "workspaces"),

  -- to change directory for all of nvim (:cd) or only for the current window (:lcd)
  -- if you are unsure, you likely want this to be true.
  global_cd = true,

  -- sort the list of workspaces by name after loading from the workspaces path.
  sort = true,

  -- enable info-level notifications after adding or removing a workspace
  notify_info = true,

  -- lists of hooks to run after specific actions
  -- hooks can be a lua function or a vim command (string)
  -- if only one hook is needed, the list may be omitted
  hooks = {
    add = {},
    remove = {},
    open_pre = {
      -- -- If recording, save current session state and stop recording
      -- "SessionsStop",

      -- -- delete all buffers (does not save changes)
      -- "silent %bdelete!",
      -- "SaveSession",
    },
    open = {
      -- function(dir)
      --   local Lib = require "auto-session-library"
      --   Lib.conf.last_loaded_session = nil
      --   vim.cmd "RestoreSession"
      -- end,
      -- function()
      --   require("sessions").load(nil, { silent = true })
      -- end,
      -- "NvimTreeOpen",
    },
  },
}
M.config_sessions = {
  events = { "VimLeavePre" },
  session_filepath = ".nvim/session",
}

M.setup_workspaces = function()
  require("workspaces").setup(M.config_workspace)
  require("telescope").load_extension "workspaces"
  local wk = require "plugins.which_key"
  wk.config.nmappings["s"]["p"] = { ":lua require('plugins.workspaces').workspaces()<cr>", "workspaces" }
end

M.setup_sessions = function()
  require("sessions").setup(M.config_sessions)
end

function M.workspaces()
  local opts = require("plugins.telescope").dropdown_opts()
  opts.initial_mode = "normal"
  require("telescope").extensions.workspaces.workspaces(opts)
end

return M
