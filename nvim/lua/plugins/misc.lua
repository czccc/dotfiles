local M = {}

M.packers = {
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "Tastyep/structlog.nvim" },
  { "lewis6991/impatient.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  -- {
  --   "henriquehbr/nvim-startup.lua",
  --   config = function()
  --     require("nvim-startup").setup()
  --   end,
  -- },
  {
    "antoinemadec/FixCursorHold.nvim",
    event = "BufRead",
  },
  { "mtdl9/vim-log-highlighting", ft = { "text", "log" } },
  { "b0o/schemastore.nvim" },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup { easing_function = "quadratic" }
    end,
    event = "BufRead",
    disable = false,
  },
  {
    "yamatsum/nvim-cursorline",
    opt = true,
    event = "BufWinEnter",
    disable = true,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, { css = true })
    end,
    event = { "BufRead" },
  },
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit",
          "gitrebase",
          "svn",
          "hgcommit",
        },
        lastplace_open_folds = true,
      }
    end,
    event = "BufWinEnter",
    disable = false,
  },
  -- {
  --   "tpope/vim-surround",
  -- },
  {
    "machakann/vim-sandwich",
    config = function()
      require("plugins.misc").setup_sandwich()
    end,
    event = "BufRead",
  },
  {
    "mbbill/undotree",
    config = function()
      require("plugins.misc").setup_undotree()
    end,
    cmd = { "UndotreeToggle" },
  },
  {
    "chentau/marks.nvim",
    config = function()
      require("plugins.misc").setup_marks()
    end,
  },
}

M.config = {}

M.setup = function() end

M.setup_sandwich = function()
  vim.cmd [[
    let g:sandwich_no_default_key_mappings = 1
    silent! nmap <unique><silent> Sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    silent! nmap <unique><silent> Sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    silent! nmap <unique><silent> Sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
    silent! nmap <unique><silent> Srb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

    let g:operator_sandwich_no_default_key_mappings = 1
    let g:textobj_sandwich_no_default_key_mappings = 1
    " add
    silent! map <unique> Sa <Plug>(operator-sandwich-add)
    " delet[e
    silent! xmap <unique> Sd <Plug>(operator-sandwich-delete)
    " replace
    silent! xmap <uni]que> Sr <Plug>(operator-sandwich-replace)
  ]]
end

M.setup_undotree = function()
  vim.cmd [[ let g:undotree_WindowLayout = 3 ]]
  vim.cmd [[ let g:undotree_SetFocusWhenToggle = 1 ]]
end

M.setup_marks = function()
  require("marks").setup {
    -- whether to map keybinds or not. default true
    default_mappings = true,
    -- which builtin marks to show. default {}
    builtin_marks = { "<", ">", "^" },
    -- whether movements cycle back to the beginning/end of buffer. default true
    cyclic = true,
    -- whether the shada file is updated after modifying uppercase marks. default false
    force_write_shada = false,
    -- how often (in ms) to redraw signs/recompute mark positions.
    -- higher values will have better performance but may cause visual lag,
    -- while lower values may cause performance penalties. default 150.
    refresh_interval = 250,
    -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
    -- marks, and bookmarks.
    -- can be either a table with all/none of the keys, or a single number, in which case
    -- the priority applies to all marks.
    -- default 10.
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    -- disables mark tracking for specific filetypes. default {}
    excluded_filetypes = {},
    -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
    -- sign/virttext. Bookmarks can be used to group together positions and quickly move
    -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
    -- default virt_text is "".
    bookmark_0 = {
      sign = "⚑",
      virt_text = "hello world",
    },
    mappings = {},
  }
end
return M
