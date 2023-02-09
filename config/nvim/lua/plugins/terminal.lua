local utils = require("utils")

local toggle = function(opts)
  opts = opts or {}
  local cmd = opts.cmd or opts[1]
  local cwd = opts.cwd or opts[2] or vim.fn.getcwd()
  local dir = opts.dir or opts[3] or "float"
  if opts.cmd then
    local binary = opts.cmd:match("(%S+)")
    if vim.fn.executable(binary) ~= 1 then
      vim.notify("Unknown cmd: " .. binary .. ". Please make sure it is installed properly.", vim.log.levels.INFO)
      return
    end
  end
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = cmd,
    dir = cwd,
    hidden = true,
    direction = dir,
  })
  term:toggle()
end

local task_select = function()
  local tasks = vim.fn["asynctasks#list"]("")
  local max_len = 0
  if not tasks or #tasks == 0 then
    vim.notify("No AsyncTasks.")
    return
  end
  for _, v in ipairs(tasks) do
    if #v.name > max_len then
      max_len = #v.name
    end
  end
  max_len = max_len + 2
  vim.ui.select(tasks, {
    prompt = "Select Tasks:",
    format_item = function(item)
      return string.format("%-" .. max_len .. "s", item.name) .. item.command
    end,
  }, function(choice)
    if choice then
      vim.cmd("AsyncTask " .. choice.name)
    end
  end)
end

local asyncrun = {
  "skywind3000/asyncrun.vim",
  lazy = true,
  event = { "VeryLazy" },
  init = function()
    vim.cmd([[ let g:asyncrun_open = 8 ]])
    vim.cmd([[ let g:asyncrun_mode = 'term' ]])
  end,
  keys = {
    { "<Leader>th", "<cmd>AsyncRun zsh<cr>", desc = "Horizontal" },
    { "<Leader>tv", "<cmd>AsyncRun -pos=right zsh<cr>", desc = "Vertical" },
  },
}

local asynctask = {
  "skywind3000/asynctasks.vim",
  lazy = true,
  event = { "VeryLazy" },
  init = function()
    vim.cmd([[ let g:asynctask_template = '~/.config/nvim/task_template.ini' ]])
    vim.cmd([[ let g:asynctasks_extra_config = ['~/.config/nvim/tasks.ini'] ]])
    vim.cmd([[ let g:asynctasks_mode = 'term' ]])
    vim.cmd([[ let g:asynctasks_term_pos = 'bottom' ]])
    vim.cmd([[ let g:asynctasks_term_rows = 10 ]])
    vim.cmd([[ let g:asynctasks_term_reuse = 1 ]])
  end,
  keys = {
    { "<Leader>st", task_select, desc = "AsyncTask" },
    { "<F5>", "<cmd>AsyncTask run<cr>", desc = "AsyncTask run" },
    { "<F6>", "<cmd>AsyncTask build<cr>", desc = "AsyncTask build" },
    { "<F7>", "<cmd>AsyncTaskLast<cr>", desc = "AsyncTask Last" },
    { "<F8>", task_select, desc = "AsyncTask" },
  },
}

local toggleterm = {
  "akinsho/toggleterm.nvim",
  lazy = true,
  event = { "VeryLazy" },
  init = function()
    utils.keymap.group("n", "<Leader>t", "Terminal/Test")
  end,
  opts = {
    -- size can be a number or function which is passed the current terminal
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = false, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
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
  config = function(spec, opts)
    require("toggleterm").setup(opts)
  end,
  keys = {
    { "<Leader>gg", utils.wrap(toggle, { "lazygit" }), desc = "Lazygit" },
    { "<Leader>gG", utils.wrap(toggle, { "gitui" }), desc = "Git UI" },

    { "<Leader>tt", utils.wrap(toggle), desc = "Float" },
    { "<Leader>tH", utils.wrap(toggle, { "htop" }), desc = "Htop" },
  },
}

return {
  toggleterm,
  asyncrun,
  asynctask,
}
