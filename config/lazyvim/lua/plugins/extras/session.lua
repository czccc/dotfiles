-- local function restore_nvim_tree()
--   local neotree_status_ok, neotree = pcall(require, "neo-tree.command")
--   if neotree_status_ok then
--     pcall(vim.cmd, [[ Neotree ]])
--     return
--   end
-- end

local separator = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
local join = function(...)
  return table.concat({ ... }, separator)
end

return {
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "Shatur/neovim-session-manager",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    init = function()
      -- local sessions_dir = join(vim.fn.stdpath("data"), "sessions")
      -- local stat = vim.loop.fs_stat(sessions_dir)
      -- if not stat then
      --   vim.fn.system({
      --     "mkdir",
      --     sessions_dir,
      --   })
      -- end
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "SessionLoadPost",
      --   callback = function()
      --     local neotree_status_ok, _ = pcall(require, "neo-tree.command")
      --     if neotree_status_ok then
      --       pcall(vim.cmd, [[ Neotree ]])
      --       pcall(vim.cmd, [[ wincmd = ]])
      --       return
      --     end
      --   end,
      -- })
    end,
    opts = {
      sessions_dir = join(vim.fn.stdpath("data"), "sessions"), -- The directory where the session files will be saved.
      -- path_replacer = "__", -- The character to which the path separator will be replaced for session files.
      -- colon_replacer = "++", -- The character to which the colon symbol will be replaced for session files.
      autoload_mode = "Disabled", -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
      autosave_last_session = true, -- Automatically save last session on exit and on session switch.
      autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
      autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
        "gitcommit",
        "Outline",
        "NvimTree",
        "neo-tree",
        "nofile",
      },
      autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
      max_path_length = 120, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
    },
    keys = {
      { "<Leader>sp", "<cmd>SessionManager load_session<cr>", desc = "Projects" },
      { "<Leader>qs", "<cmd>SessionManager save_current_session<cr>", desc = "Save" },
      { "<Leader>qc", "<cmd>SessionManager load_current_dir_session<cr>", desc = "Restore CurDir" },
      { "<Leader>ql", "<cmd>SessionManager load_last_session<cr>", desc = "Restore Last" },
      { "<Leader>qd", "<cmd>SessionManager delete_session<cr>", desc = "Delete" },
      { "<Leader>qp", "<cmd>SessionManager load_session<cr>", desc = "List" },
    },
  },
}
