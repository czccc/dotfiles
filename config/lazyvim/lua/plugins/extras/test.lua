return {
  {
    "mbbill/undotree",
    init = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
    keys = { { "<Leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" } },
    cmd = { "UndotreeToggle" },
  },
}
