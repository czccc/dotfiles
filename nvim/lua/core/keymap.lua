local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
}

M.config = function()
  gconf.keys.insert_mode = {
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
  }

  gconf.keys.normal_mode = {
    ["<Esc>"] = ":noh<CR>",
    ["<C-a>"] = "ggVG",
    ["<C-s>"] = ":w<CR>",
    ["D"] = "d$",
    ["Y"] = "y$",
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

    -- ["<S-l>"] = ":BufferLineCycleNext<CR>",
    -- ["<S-h>"] = ":BufferLineCyclePrev<CR>",

    ["<A-j>"] = ":m .+1<CR>==",
    ["<A-k>"] = ":m .-2<CR>==",

    ["]q"] = ":cnext<CR>",
    ["[q"] = ":cprev<CR>",
    ["<C-q>"] = ":call QuickFixToggle()<CR>",
  }

  gconf.keys.term_mode = {
    ["<C-h>"] = "<C-\\><C-N><C-w>h",
    ["<C-j>"] = "<C-\\><C-N><C-w>j",
    ["<C-k>"] = "<C-\\><C-N><C-w>k",
    ["<C-l>"] = "<C-\\><C-N><C-w>l",
  }

  ---@usage change or add keymappings for visual mode
  gconf.keys.visual_mode = {
    ["p"] = [["_dP]],
    ["c"] = [["_c]],
    ["s"] = [["_c]],
    ["x"] = [["_x]],
    -- ["p"] = '"0p',
    -- ["P"] = '"0P',

    ["<"] = "<gv",
    [">"] = ">gv",
  }

  gconf.keys.visual_block_mode = {
    ["K"] = ":move '<-2<CR>gv-gv",
    ["J"] = ":move '>+1<CR>gv-gv",

    ["<A-j>"] = ":m '>+1<CR>gv-gv",
    ["<A-k>"] = ":m '<-2<CR>gv-gv",
  }

  gconf.keys.command_mode = {
    ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
    ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
  }
end

M.setup = function()
  M.load(gconf.keys)
end

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
  local opt = generic_opts[mode] or generic_opts_any
  if type(val) == "table" then
    opt = val[2]
    val = val[1]
  end
  if val then
    vim.api.nvim_set_keymap(mode, key, val, opt)
  else
    pcall(vim.api.nvim_del_keymap, mode, key)
  end
end

function M.load(keymaps)
  keymaps = keymaps or {}
  for mode, mapping in pairs(keymaps) do
    mode = mode_adapters[mode] or mode
    for k, v in pairs(mapping) do
      M.set_keymaps(mode, k, v)
    end
  end
end

return M
