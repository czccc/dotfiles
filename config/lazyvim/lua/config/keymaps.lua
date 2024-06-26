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

map("n", "<leader>L", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })

-- Move Blocks
map("x", "J", "<cmd>move '>+1<CR>gv-gv<CR>", { desc = "Move Block Down" })
map("x", "K", "<cmd>move '>-2<CR>gv-gv<CR>", { desc = "Move Block Up" })
map("x", "<A-j>", "<cmd>move '>+1<CR>gv-gv<CR>", { desc = "Move Block Down" })
map("x", "<A-k>", "<cmd>move '>-2<CR>gv-gv<CR>", { desc = "Move Block Up" })

map("n", "[<Space>", "<cmd>put!=repeat(nr2char(10), v:count1)|silent<CR>", { desc = "Prev Add Lines" })
map("n", "]<Space>", "<cmd>put =repeat(nr2char(10), v:count1)|silent<CR>", { desc = "Prev Add Lines" })

map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- quit
map("n", "<Leader>Q", "<cmd>wqa<cr>", { desc = "Quit" })

-- windows
map("n", "<leader>w=", "<C-W>=", { desc = "Resize Windows", remap = true })
map("n", "<leader>=", "<C-W>=", { desc = "Resize Windows", remap = true })

map("x", "p", [["zdP]])
map({ "n", "x" }, "x", [["-x]])
map({ "n", "x" }, "c", [["-c]])

map("n", "<F2>", [[yiw:%s/\<<C-r>"\>/<C-r>"/gc<Left><Left><Left>]], { desc = "Substitute CurWord" })
map("v", "<F2>", [[y:%s/\<<C-r>"\>/<C-r>"/gc<Left><Left><Left>]], { desc = "Substitute CurWord" })
map("n", "<F3>", "yiw", { desc = "Yank CurWord" })
map("n", "<F4>", 'viw"zdP', { desc = "Paste CurWord" })
