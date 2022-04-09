local M = {}

M.packer = {
  "goolord/alpha-nvim",
  config = function()
    require("plugins.alpha").setup()
  end,
  disable = false,
}

local function make_infos()
  local plugins = #vim.tbl_keys(packer_plugins)
  local v = vim.version()
  local datetime = os.date " %Y-%m-%d   %H:%M:%S"
  return string.format("%s   v%d.%d.%d   %d", datetime, v.major, v.minor, v.patch, plugins)
end

function M.setup()
  ---@diagnostic disable-next-line: different-requires
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"
  local header = dashboard.section.header
  header.val = require("utils.banners").dashboard()
  local footer = dashboard.section.footer
  footer.val = require "alpha.fortune"()
  local infos = {
    type = "text",
    val = make_infos(),
    opts = {
      position = "center",
      hl = "Number",
    },
  }

  local buttons = dashboard.section.buttons
  buttons.val = {
    dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  > Recent Files", ":Telescope frecency<CR>"),
    dashboard.button("s", "  > Restore Session", ":SessionManager load_current_dir_session<CR>"),
    dashboard.button("S", "  > Sessions", ":SessionManager load_session<CR>"),
    dashboard.button("q", "  > Quit NVIM", ":q<CR>"),
  }

  local config = {
    layout = {
      { type = "padding", val = 2 },
      header,
      { type = "padding", val = 2 },
      buttons,
      { type = "padding", val = 2 },
      infos,
      footer,
    },
    opts = {
      margin = 5,
    },
  }

  alpha.setup(config)
  require("core.autocmds").define_augroups {
    alpha = {
      {
        "FileType",
        "alpha",
        "setlocal nofoldenable",
      },
    },
  }
end

return M
