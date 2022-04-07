local M = {}
local path = require "utils.path"
local Log = require "core.log"

M.keys = {
  -- insert mode
  ["i"] = {
    ["<C-a>"] = "<ESC>ggVG",
    ["<C-s>"] = "<ESC>:w<CR>",

    ["jk"] = "<ESC>",
    ["kj"] = "<ESC>",
    ["jj"] = "<ESC>",

    ["<A-j>"] = "<Esc>:m .+1<CR>==gi",
    ["<A-k>"] = "<Esc>:m .-2<CR>==gi",

    ["<A-Up>"] = "<C-\\><C-N><C-w>k",
    ["<A-Down>"] = "<C-\\><C-N><C-w>j",
    ["<A-Left>"] = "<C-\\><C-N><C-w>h",
    ["<A-Right>"] = "<C-\\><C-N><C-w>l",
  },
  -- normal mode
  ["n"] = {
    ["<Esc>"] = ":noh<CR>",
    ["<C-a>"] = "ggVG",
    ["<C-s>"] = ":w<CR>",
    ["D"] = "d$",
    ["Y"] = "y$",
    -- ["s"] = "viw",
    ["s"] = "viw",
    ["c"] = [["_c]],
    ["x"] = [["_x]],

    ["<C-h>"] = "<C-w>h",
    ["<C-j>"] = "<C-w>j",
    ["<C-k>"] = "<C-w>k",
    ["<C-l>"] = "<C-w>l",

    ["<C-Up>"] = ":resize -2<CR>",
    ["<C-Down>"] = ":resize +2<CR>",
    ["<C-Left>"] = ":vertical resize -2<CR>",
    ["<C-Right>"] = ":vertical resize +2<CR>",

    ["<A-j>"] = ":m .+1<CR>==",
    ["<A-k>"] = ":m .-2<CR>==",
  },
  -- term mode
  ["t"] = {
    ["<C-h>"] = "<C-\\><C-N><C-w>h",
    ["<C-j>"] = "<C-\\><C-N><C-w>j",
    ["<C-k>"] = "<C-\\><C-N><C-w>k",
    ["<C-l>"] = "<C-\\><C-N><C-w>l",
  },
  -- visual mode
  ["v"] = {
    ["p"] = [["_dP]],
    ["c"] = [["_c]],
    ["s"] = [["_c]],
    ["x"] = [["_x]],
    -- ["p"] = '"0p',
    -- ["P"] = '"0P',

    ["<"] = "<gv",
    [">"] = ">gv",
  },
  -- visual block mode
  ["x"] = {
    ["K"] = ":move '<-2<CR>gv-gv",
    ["J"] = ":move '>+1<CR>gv-gv",

    ["<A-j>"] = ":m '>+1<CR>gv-gv",
    ["<A-k>"] = ":m '<-2<CR>gv-gv",
  },
  -- command mode
  ["c"] = {
    ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
    ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
  },
}

M.mac_keys = {
  ["n"] = {
    ["<A-Up>"] = M.keys["n"]["<C-Up>"],
    ["<A-Down>"] = M.keys["n"]["<C-Down>"],
    ["<A-Left>"] = M.keys["n"]["<C-Left>"],
    ["<A-Right>"] = M.keys["n"]["<C-Right>"],
  },
}

M.setup = function()
  M.load(M.keys)
  if path.is_mac then
    M.load(M.mac_keys)
    Log:debug "Activated mac keymappings"
  end
end

M.load = function(keymaps)
  keymaps = keymaps or {}
  for mode, mapping in pairs(keymaps) do
    local opts = { noremap = true, silent = true }
    for key, val in pairs(mapping) do
      if type(val) == "table" then
        opts = val[2]
        val = val[1]
      end
      vim.api.nvim_set_keymap(mode, key, val, opts)
    end
  end
end

return M
