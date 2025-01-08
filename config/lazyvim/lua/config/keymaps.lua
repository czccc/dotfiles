-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  if opts.remap and not vim.g.vscode then
    opts.remap = nil
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Clear search with <esc>
-- map({ "i", "n" }, "<esc>", "<cmd>noh<cr><cmd>fc<cr><esc>", { desc = "Escape and Clear hlsearch" })
--

-- lazy
map("n", "<leader>L", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })

-- add space line
map("n", "[<Space>", "<cmd>put!=repeat(nr2char(10), v:count1)|silent<CR>", { desc = "Prev Add Lines" })
map("n", "]<Space>", "<cmd>put =repeat(nr2char(10), v:count1)|silent<CR>", { desc = "Prev Add Lines" })

-- map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- quit
map("n", "<Leader>Q", "<cmd>wqa<cr>", { desc = "Quit" })

-- windows
map("n", "<leader>w=", "<C-W>=", { desc = "Resize Windows", remap = true })
map("n", "<leader>=", "<C-W>=", { desc = "Resize Windows", remap = true })

-- cut, delete, paste
map("x", "p", [["zdP]])
map({ "n", "x" }, "x", [["-x]])
map({ "n", "x" }, "c", [["-c]])

-- find, replace
map("n", "<F2>", [[yiw:%s/\<<C-r>"\>/<C-r>"/gc<Left><Left><Left>]], { desc = "Substitute CurWord" })
map("v", "<F2>", [[y:%s/\<<C-r>"\>/<C-r>"/gc<Left><Left><Left>]], { desc = "Substitute CurWord" })
map("n", "<F3>", "yiw", { desc = "Yank CurWord" })
map("n", "<F4>", 'viw"zdP', { desc = "Paste CurWord" })

-- skip pairs
map("i", "<Tab>", function()
  local next_char = vim.api.nvim_eval("strcharpart(getline('.')[col('.') - 1:], 0, 1)")
  if
    next_char == '"'
    or next_char == "'"
    or next_char == "`"
    or next_char == ")"
    or next_char == "]"
    or next_char == "}"
  then
    local key = vim.api.nvim_replace_termcodes("<Right>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", false)
  else
    local key = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", false)
  end
end, { desc = "Paste CurWord" })
