gconf = {
  leader = "space",
  colorscheme = "default",
  transparent_window = false,
  format_on_save = {
    ---@usage pattern string pattern used for the autocommand (Default: '*')
    pattern = "*",
    ---@usage timeout number timeout in ms for the format request (Default: 1000)
    timeout = 1000,
  },
  opts = {}, -- options.lua
  wopts = {}, -- options.lua
  disabled_plugins = {}, -- options.lua
  keys = {
    insert_mode = {},
    normal_mode = {},
    visual_mode = {},
    visual_block_mode = {},
    command_mode = {},
    term_mode = {},
  },
  which_keys = {
    insert_mode = {},
    normal_mode = {},
    visual_mode = {},
    visual_block_mode = {},
    command_mode = {},
    term_mode = {},
  },
  autocommands = {},
  plugins = {
    packers = {},
  },
  lsp = {},
  lang = {},
  log = {
    ---@usage can be { "trace", "debug", "info", "warn", "error", "fatal" },
    level = "warn",
    viewer = {
      ---@usage this will fallback on "less +F" if not found
      cmd = "lnav",
      layout_config = {
        ---'vertical' | 'horizontal' | 'window' | 'float',
        direction = "horizontal",
        open_mapping = "",
        size = 40,
        float_opts = {},
      },
    },
    -- currently disabled due to instabilities
    override_notify = false,
  },
}

function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end
