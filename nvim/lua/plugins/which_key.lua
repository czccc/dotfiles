local M = {}
-- https://github.com/folke/which-key.nvim
gconf.plugins.which_key = {}

M.packer = {
  "folke/which-key.nvim",
  -- commit = "28d2bd129575b5e9ebddd88506601290bb2bb221",
  event = "BufWinEnter",
  disable = false,
  config = function()
    require("plugins.which_key").setup()
  end,
}

M.config = function()
  gconf.plugins.which_key = {
    ---@usage disable which-key completely [not recommended]
    setup = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ...
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
        spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
      },
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
    },
    opts = {
      mode = "n", -- NORMAL mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    },
    vopts = {
      mode = "v", -- VISUAL mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    },
    -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
    -- see https://neovim.io/doc/user/map.html#:map-cmd
    vmappings = {},
    mappings = {
      ["w"] = { "<cmd>w!<CR>", "Save" },
      ["q"] = { "<cmd>q!<CR>", "Quit" },
      ["Q"] = { "<cmd>wqa<cr>", "Quit" },
      ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
      ["p"] = {
        name = "Packer",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
        r = { "<cmd>lua require('core.pack').reload()<cr>", "Reload" },
      },
      ["f"] = {
        name = "Find Files",
        b = { "<cmd>lua require('plugins.telescope').curbuf()<cr>", "Current Buffer" },
        B = { "<cmd>lua require('plugins.telescope').file_browser()<cr>", "File Browser" },
        e = { "<cmd>Telescope oldfiles<cr>", "History" },
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        g = { "<cmd>lua require('plugins.telescope').git_files()<cr>", "Git Files" },
        j = { "<cmd>Telescope jumplist<cr>", "Jumplists" },
        l = { "<cmd>Telescope resume<cr>", "Resume" },
        m = { "<cmd>Telescope marks<cr>", "Marks" },
        p = { "<cmd>lua require('plugins.telescope').project_search()<cr>", "Project Files" },
        r = { "<cmd>lua require('plugins.telescope').workspace_frequency()<cr>", "Frecency" },
        s = { "<cmd>lua require('plugins.telescope').git_status()<cr>", "Git Status" },
        t = { "<cmd>TodoTelescope<cr>", "Todo" },
        w = { "<cmd>lua require('plugins.telescope').live_grep()<cr>", "Live Grep" },
        W = { "<cmd>lua require('plugins.telescope').grep_cursor_string()<cr>", "Live Grep Words" },
        z = { "<cmd>lua require('plugins.telescope').search_only_certain_files()<cr>", "Certain Filetype" },
      },
      ["s"] = {
        name = "Search",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        C = {
          "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
          "Colorscheme with Preview",
        },
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        i = { "<cmd>lua require('plugins.telescope').installed_plugins()<cr>", "Installed Plugins" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
        m = { "<cmd>Telescope commands<cr>", "Commands" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        p = { "<cmd>lua require('plugins.telescope').projects()<cr>", "Projects" },
        r = { "<cmd>Telescope registers<cr>", "Registers" },
        s = { "<cmd>Telescope<cr>", "Telescope" },
      },
      ["u"] = {
        name = "Utils",
        z = { "<cmd>ZenMode<cr>", "Zen Mode" },
        s = { "<cmd>SymbolsOutline<cr>", "Symbol Outline" },
        D = { "<cmd>DiffviewFileHistory<cr>", "diffview: diff HEAD" },
        d = { "<cmd>DiffviewOpen<cr>", "diffview: diff HEAD" },
        e = { "<cmd>SidebarNvimToggle<CR>", "Sidebar" },
        a = { "<cmd>Alpha<CR>", "Dashboard" },
        S = {
          name = "+Session",
          s = { "<cmd>SaveSession<cr>", "SaveSession" },
          r = { "<cmd>RestoreSession<cr>", "RestoreSession" },
          d = { "<cmd>DeleteSession<cr>", "DeleteSession" },
        },
      },
    },
    key_desc = {},
  }
end

M.setup = function()
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    print "which-key not loaded"
    return
  end

  which_key.setup(gconf.plugins.which_key.setup)

  local opts = gconf.plugins.which_key.opts
  local vopts = gconf.plugins.which_key.vopts

  local mappings = gconf.plugins.which_key.mappings
  local vmappings = gconf.plugins.which_key.vmappings

  which_key.register(mappings, opts)
  which_key.register(vmappings, vopts)

  require("plugins.which_key").add_desc_group()
end

M.add_desc = function(keymap, desc, mode, group)
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    print "which-key not loaded"
    return
  end
  -- print("setting " .. keymap .. " " .. desc)
  if group then
    which_key.register({ [keymap] = { name = desc } }, { mode = mode })
  else
    which_key.register({ [keymap] = { desc } }, { mode = mode })
  end
end

M.add_desc_group = function()
  for _, exec in pairs(gconf.plugins.terminal.execs) do
    M.add_desc(exec[2], exec[3], "n")
    -- M._add_desc(exec[2], exec[3], "t")
  end
  M.add_desc("<Leader>t", "Terminal", "n", true)
  M.add_desc("<C-\\>", "Terminal", "n")

  M.add_desc("gc", "Line Comment", "n")
  M.add_desc("gcc", "Line Comment", "n")
  M.add_desc("gc", "Line Comment", "v")
  M.add_desc("gb", "Block Comment", "n")
  M.add_desc("gbc", "Block Comment", "n")
  M.add_desc("gb", "Block Comment", "v")

  M.add_desc("<C-y>", "Scroll UP Little", "n")
  M.add_desc("<C-u>", "Scroll UP Much", "n")
  M.add_desc("<C-b>", "Scroll UP Page", "n")
  M.add_desc("<C-e>", "Scroll Down Little", "n")
  M.add_desc("<C-d>", "Scroll Down Much", "n")
  M.add_desc("<C-f>", "Scroll Down Page", "n")

  M.add_desc("<A-k>", "Move Text Up", "n")
  M.add_desc("<A-j>", "Move Text Down", "n")
end

return M
