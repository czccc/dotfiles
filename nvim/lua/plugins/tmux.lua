local M = {}

M.packer = {
  "aserowy/tmux.nvim",
  config = function()
    require("plugins.tmux").setup()
  end,
}

M.config = {
  copy_sync = {
    -- enables copy sync and overwrites all register actions to
    -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
    enable = false,

    -- ignore specific tmux buffers e.g. buffer0 = true to ignore the
    -- first buffer or named_buffer_name = true to ignore a named tmux
    -- buffer with name named_buffer_name :)
    ignore_buffers = { empty = false },

    -- TMUX >= 3.2: yanks (and deletes) will get redirected to system
    -- clipboard by tmux
    redirect_to_clipboard = false,

    -- offset controls where register sync starts
    -- e.g. offset 2 lets registers 0 and 1 untouched
    register_offset = 2,

    -- sync clipboard overwrites vim.g.clipboard to handle * and +
    -- registers. If you sync your system clipboard without tmux, disable
    -- this option!
    sync_clipboard = true,

    -- syncs deletes with tmux clipboard as well, it is adviced to
    -- do so. Nvim does not allow syncing registers 0 and 1 without
    -- overwriting the unnamed register. Thus, ddp would not be possible.
    sync_deletes = true,

    -- syncs the unnamed register with the first buffer entry from tmux.
    sync_unnamed = true,
  },
  navigation = {
    -- cycles to opposite pane while navigating into the border
    cycle_navigation = true,

    -- enables default keybindings (C-hjkl) for normal mode
    enable_default_keybindings = true,

    -- prevents unzoom tmux when navigating beyond vim border
    persist_zoom = false,
  },
  resize = {
    -- enables default keybindings (A-hjkl) for normal mode
    enable_default_keybindings = false,

    -- sets resize steps for x axis
    resize_step_x = 1,

    -- sets resize steps for y axis
    resize_step_y = 1,
  },
}

M.setup = function()
  ---@diagnostic disable-next-line: redundant-parameter
  require("tmux").setup(M.config)
  local wk = require "plugins.which_key"
  wk.register {
    ["t"] = {
      ["m"] = {
        name = "Tmux",
        ["h"] = { [[<cmd>lua require("tmux").move_left()<cr>]], "Left" },
        ["j"] = { [[<cmd>lua require("tmux").move_bottom()<cr>]], "Bottom" },
        ["k"] = { [[<cmd>lua require("tmux").move_up()<cr>]], "Up" },
        ["l"] = { [[<cmd>lua require("tmux").move_right()<cr>]], "Right" },
      },
    },
  }
  wk.register({
    ["<C-h>"] = "Move Left",
    ["<C-j>"] = "Move Bottom",
    ["<C-k>"] = "Move Up",
    ["<C-l>"] = "Move Right",
  }, wk.config.opts)
end

return M
