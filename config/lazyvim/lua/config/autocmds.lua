-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("User", {
  group = augroup("telescope_preview_add_line"),
  pattern = { "TelescopePreviewerLoaded" },
  callback = function()
    -- vim.bo.number = true
    vim.cmd([[setlocal number]])
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("symbol_outline_add_tab"),
  pattern = { "Outline" },
  callback = function(event)
    vim.keymap.set("n", "<Tab>", "<cmd>wincmd l<cr>", { buffer = event.buf, silent = true })
  end,
})
