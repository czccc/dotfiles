-- local function restore_nvim_tree()
--   local neotree_status_ok, neotree = pcall(require, "neo-tree.command")
--   if neotree_status_ok then
--     pcall(vim.cmd, [[ Neotree ]])
--     return
--   end
-- end

return {
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      auto_session_create_enabled = false,
      auto_session_suppress_dirs = { "~/", "/" },
      -- post_restore_cmds = { restore_nvim_tree, "wincmd =" },
    },
    keys = {
      { "<Leader>qs", "<cmd>SessionSave<cr>", desc = "Save Current" },
      { "<Leader>qc", "<cmd>SessionRestore<cr>", desc = "Restore Current" },
      { "<Leader>qD", "<cmd>SessionPurgeOrphaned<cr>", desc = "Purge Orphaned" },
      { "<Leader>qd", "<cmd>SessionDelete<cr>", desc = "Delete Current" },
      { "<Leader>qp", "<cmd>Autosession search<cr>", desc = "Restore By Search" },
      { "<Leader>qP", "<cmd>Autosession delete<cr>", desc = "Delete By Search" },
    },
  },
}
