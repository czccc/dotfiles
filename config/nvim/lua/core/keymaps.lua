local utils = require("utils")
local keymap = utils.keymap.set
local group = utils.keymap.group
local desc = utils.keymap.desc

group("n", "<Leader>", "Leader")
group("n", "[", "Previous Move")
group("n", "]", "Next Move")
group("n", "g", "Goto")
group("n", "z", "Fold")
group("n", "<Leader>m", "Module")
group("n", "<Leader>u", "Utils")
group("n", "[o", "Toggle ON")
group("n", "]o", "Toggle OFF")
group("n", "yo", "Toggle")

desc("n", "<C-y>", "Scroll UP Little")
desc("n", "<C-u>", "Scroll UP Much")
desc("n", "<C-b>", "Scroll UP Page")
desc("n", "<C-e>", "Scroll Down Little")
desc("n", "<C-d>", "Scroll Down Much")
desc("n", "<C-f>", "Scroll Down Page")

-- insert mode
keymap("i", "<C-a>", "<Esc>ggVG", "Select All")
keymap("i", "<C-s>", "<Esc><cmd>w<CR>", "Write")
keymap("i", "<C-u>", "<C-G>u<C-u>", "Delete Before")
keymap("i", "<C-w>", "<C-G>u<C-w>", "Delete Word")
-- Key("i", "<CR>", "<C-G>u<CR>", "CR")
keymap("i", "jj", "<Esc>")
keymap("i", "jk", "<Esc>")
keymap("i", "kj", "<Esc>")
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", "Move Line Down")
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", "Move Line Up")
keymap("i", "<A-Left>", "<C-\\><C-N><C-w>h", "Navigate Left")
keymap("i", "<A-Down>", "<C-\\><C-N><C-w>j", "Navigate Down")
keymap("i", "<A-Up>", "<C-\\><C-N><C-w>k", "Navigate Up")
keymap("i", "<A-Right>", "<C-\\><C-N><C-w>l", "Navigate Right")

-- normal mode
keymap("n", "<C-a>", "ggVG", "Select All")
keymap("n", "<C-s>", ":w<CR>", "Write")
keymap("n", "<Esc>", ":noh<CR>", "No Highlight")
keymap("n", "D", "d$")
keymap("n", "Y", "y$")
keymap("x", "p", [["_dP]])
-- Key({ "n", "x" }, "p", [["0p]])
-- Key({ "n", "x" }, "P", [["0P]])
keymap({ "n", "x" }, "x", [["-x]])
keymap({ "n", "x" }, "c", [["-c]])
keymap({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
keymap({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
keymap({ "n", "x", "o" }, "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
keymap({ "n", "x", "o" }, "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
keymap("n", "gj", "j")
keymap("n", "gk", "k")
keymap("n", "<C-h>", "<C-w>h", "Navigate Left")
keymap("n", "<C-j>", "<C-w>j", "Navigate Down")
keymap("n", "<C-k>", "<C-w>k", "Navigate Up")
keymap("n", "<C-l>", "<C-w>l", "Navigate Right")
keymap("n", "<C-Up>", ":resize -2<CR>", "Resize Up")
keymap("n", "<C-Down>", ":resize +2<CR>", "Resize Down")
keymap("n", "<C-Left>", ":vertical resize -2<CR>", "Resize Left")
keymap("n", "<C-Right>", ":vertical resize +2<CR>", "Resize Right")
keymap("n", "<A-j>", ":m .+1<CR>==", "Move Line Down")
keymap("n", "<A-k>", ":m .-2<CR>==", "Move Line Up")
-- macos
keymap("n", "<A-Up>", ":resize -2<CR>", "Resize Up")
keymap("n", "<A-Down>", ":resize +2<CR>", "Resize Down")
keymap("n", "<A-Left>", ":vertical resize -2<CR>", "Resize Left")
keymap("n", "<A-Right>", ":vertical resize +2<CR>", "Resize Right")
keymap("n", "<A-a>", "ggVG", "Select All")
keymap("n", "<A-s>", ":w<CR>", "Write")

keymap("n", "<F2>", [[yiw:%s/\<<C-r>"\>/<C-r>"/gc<Left><Left><Left>]], "Substitute CurWord")
keymap("v", "<F2>", [[y:%s/\<<C-r>"\>/<C-r>"/gc<Left><Left><Left>]], "Substitute CurWord")
keymap("n", "<F3>", "yiw", "Yank CurWord")
keymap("n", "<F4>", 'viw"_dP', "Paste CurWord")

keymap("n", "<Leader>=", "<C-w>=", "Resize Windows")
keymap("n", "<Leader>q", ":q!<CR>", "Force Quit")
keymap("n", "<Leader>Q", ":wqa<CR>", "Quit")
keymap("n", "<Leader>uh", ":checkhealth<CR>", "Check Health")
keymap("n", "<Leader>uH", ":checktime<CR>", "Check Time")
keymap("n", "<Leader>um", ":messages<CR>", "Messages")
keymap("n", "<Leader>un", ":Notifications<CR>", "Notifications")
keymap("n", "<Leader>uM", utils.wrap(utils.buffer.output_in_buffer, "messages"), "Messages Buffer")
keymap("n", "<Leader>uN", utils.wrap(utils.buffer.output_in_buffer, "Notifications"), "Notifications Buffer")

-- visual mode
keymap("v", "<", "<gv", "Indent Left")
keymap("v", ">", ">gv", "Indent Right")

-- visual block mode
keymap("x", "J", ":move '>+1<CR>gv-gv", "Move Block Down")
keymap("x", "K", ":move '>-2<CR>gv-gv", "Move Block Up")
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", "Move Block Down")
keymap("x", "<A-k>", ":move '>-2<CR>gv-gv", "Move Block Up")

-- term mode
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", "Navigate Left")
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", "Navigate Down")
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", "Navigate Up")
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", "Navigate Right")
keymap("t", "jk", "<C-\\><C-N>", "Normal Mode")
keymap("t", "<C-q>", "<cmd>bdelete!<CR>", "Force Quit Terminal")

-- command mode
keymap("c", "<C-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { desc = "Select Next", expr = true })
keymap("c", "<C-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { desc = "Select Previous", expr = true })

-- toggle
keymap("n", "[os", "<cmd>setlocal spell<CR>", "Spell")
keymap("n", "]os", "<cmd>setlocal nospell<CR>", "Spell")
keymap("n", "yos", "<cmd>setlocal invspell<CR>", "Spell")

keymap("n", "[ow", "<cmd>setlocal wrap<CR>", "Wrap")
keymap("n", "]ow", "<cmd>setlocal nowrap<CR>", "Wrap")
keymap("n", "yow", "<cmd>setlocal invwrap<CR>", "Wrap")

keymap("n", "[om", "<cmd>setlocal modifiable<CR>", "Modifiable")
keymap("n", "]om", "<cmd>setlocal nomodifiable<CR>", "Modifiable")
keymap("n", "yom", "<cmd>setlocal invmodifiable<CR>", "Modifiable")

keymap("n", "[oM", "<cmd>set mouse=a<CR>", "Mouse")
keymap("n", "]oM", "<cmd>set mouse=<CR>", "Mouse")
keymap("n", "yoM", function()
  if vim.api.nvim_get_option("mouse") == "a" then
    vim.api.nvim_set_option("mouse", "")
  else
    vim.api.nvim_set_option("mouse", "a")
  end
end, "Mouse")

keymap("n", "[on", "<cmd>setlocal number<CR>", "Number")
keymap("n", "]on", "<cmd>setlocal nonumber<CR>", "Number")
keymap("n", "yon", "<cmd>setlocal invnumber<CR>", "Number")

keymap("n", "[or", "<cmd>setlocal relativenumber<CR>", "Relative Number")
keymap("n", "]or", "<cmd>setlocal norelativenumber<CR>", "Relative Number")
keymap("n", "yor", "<cmd>setlocal invrelativenumber<CR>", "Relative Number")

keymap("n", "[q", "<cmd>cprevious<CR>", "Previous Quickfix")
keymap("n", "]q", "<cmd>cnext<CR>", "Next Quickfix")

keymap("n", "[<Space>", "<cmd>put!=repeat(nr2char(10), v:count1)|silent<CR>", "Previous Add Lines")
keymap("n", "]<Space>", "<cmd>put =repeat(nr2char(10), v:count1)|silent<CR>", "Previous Add Lines")
