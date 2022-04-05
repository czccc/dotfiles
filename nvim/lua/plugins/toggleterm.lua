local M = {}
local Log = require "core.log"

M.packer = {
  "akinsho/toggleterm.nvim",
  event = "BufWinEnter",
  config = function()
    require("plugins.toggleterm").setup()
  end,
  disable = false,
}

M.config = {
  setup = {
    -- size can be a number or function which is passed the current terminal
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = false,
    -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
    direction = "float",
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
      -- The border key is *almost* the same as 'nvim_win_open'
      -- see :h nvim_win_open for details on borders however
      -- the 'curved' border is a custom border type
      -- not natively supported but implemented in this plugin.
      -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      border = "curved",
      -- width = <value>,
      -- height = <value>,
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
  -- Add executables on the config.lua
  -- { exec, keymap, name, layout}
  execs = {
    ["<leader>tt"] = { "zsh", "<leader>tt", "Float", "float" },
    ["<leader>th"] = { "zsh", "<leader>th", "Horizontal", "horizontal" },
    ["<leader>tv"] = { "zsh", "<leader>tv", "Vertical", "vertical" },
    ["<leader>tg"] = { "lazygit", "<leader>tg", "LazyGit", "float" },
    ["<leader>tG"] = { "gitui", "<leader>tG", "Git UI", "float" },
    ["<leader>tp"] = { "python", "<leader>tp", "Python", "float" },
    ["<leader>tj"] = { "htop", "<leader>tj", "htop", "float" },
    ["<leader>tn"] = { "ncdu", "<leader>tn", "ncdu", "float" },
  },
}

M.setup = function()
  local status_ok, terminal = pcall(require, "toggleterm")
  if not status_ok then
    Log:warn "toggleterm not loaded"
    return
  end
  local config = M.config

  terminal.setup(config.setup)
  require("plugins.which_key").add_desc("<C-\\>", "Terminal", "n")

  local c = 0
  for _, exec in pairs(config.execs) do
    c = c + 1
    local opts = {
      cmd = exec[1],
      keymap = exec[2],
      label = exec[3],
      -- NOTE: unable to consistently bind id/count <= 9, see #2146
      count = c + 100,
      direction = exec[4] or config.setup.direction,
      size = config.setup.size,
    }
    M.add_exec(opts)
  end
  require("core.autocmds").define_augroups {
    term_open = {
      { "TermOpen", "term://*", "lua require('plugins.toggleterm').set_terminal_keymaps()" },
    },
  }
end

M.set_terminal_keymaps = function()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<C-q>", "<cmd>bdelete!<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "<esc>", [[<C-W>w]], opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<esc>", "<cmd>:q<cr>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>:q<cr>", opts)
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "n", "jk", [[<C-W>w]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

M.add_exec = function(opts)
  local binary = opts.cmd:match "(%S+)"
  if vim.fn.executable(binary) ~= 1 then
    Log:debug("Skipping configuring executable " .. binary .. ". Please make sure it is installed properly.")
    return
  end

  local exec_func = string.format(
    "<cmd>lua require('plugins.toggleterm')._exec_toggle({ cmd = '%s', count = %d, direction = '%s'})<CR>",
    opts.cmd,
    opts.count,
    opts.direction
  )

  require("core.keymap").load {
    ["n"] = { [opts.keymap] = exec_func },
    ["t"] = { [opts.keymap] = exec_func },
  }

  local wk_status_ok, wk = pcall(require, "which-key")
  if not wk_status_ok then
    return
  end
  wk.register({ [opts.keymap] = { opts.label } }, { mode = "n" })
  -- wk.register({ [opts.keymap] = { opts.label } }, { mode = "t" })
end

M._exec_toggle = function(opts)
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new { cmd = opts.cmd, count = opts.count, direction = opts.direction }
  term:toggle(M.config.setup.size, opts.direction)
end

-- ---Toggles a log viewer according to log.viewer.layout_config
-- ---@param logfile string the fullpath to the logfile
-- M.toggle_log_view = function(logfile)
-- 	local log_viewer = lvim.log.viewer.cmd
-- 	if vim.fn.executable(log_viewer) ~= 1 then
-- 		log_viewer = "less +F"
-- 	end
-- 	log_viewer = log_viewer .. " " .. logfile
-- 	local term_opts = vim.tbl_deep_extend("force", M.config.setup, {
-- 		cmd = log_viewer,
-- 		open_mapping = lvim.log.viewer.layout_config.open_mapping,
-- 		direction = lvim.log.viewer.layout_config.direction,
-- 		-- TODO: this might not be working as expected
-- 		size = lvim.log.viewer.layout_config.size,
-- 		float_opts = lvim.log.viewer.layout_config.float_opts,
-- 	})

-- 	local Terminal = require("toggleterm.terminal").Terminal
-- 	local log_view = Terminal:new(term_opts)
-- 	log_view:toggle()
-- end

return M
