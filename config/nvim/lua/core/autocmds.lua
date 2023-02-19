-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "WinEnter" }, { command = "checktime" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Search", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("VimResized", { command = "tabdo wincmd =" })

vim.api.nvim_create_autocmd(
  { "BufWinEnter", "BufRead", "BufNewFile" },
  { command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" }
)

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local last_pos = vim.fn.line("'\"")
    if not vim.fn.expand("%:p"):match(".git") and last_pos > 1 and last_pos <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
      -- vim.cmd("normal zz")
    end
  end,
})
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function() end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 0
    vim.opt_local.listchars.tab = [[\ \ ]]
    vim.opt_local.list = false
    -- vim.opt_local.listchars.tab = "  "
    -- vim.opt_local.listchars = {
    --     tab = [[\ \ ]],
    --     nbsp = "+",
    --     trail = "·",
    --     extends = "→",
    --     precedes = "←",
    -- }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Outline" },
  callback = function()
    vim.opt_local.signcolumn = false
    vim.opt_local.wrap = false
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
