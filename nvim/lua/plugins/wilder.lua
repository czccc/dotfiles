local M = {}

M.packer = {
  "gelguy/wilder.nvim",
  -- event = { "CursorHold", "CmdlineEnter" },
  -- rocks = { "luarocks-fetch-gitrec", "pcre2" },
  requires = { "romgrk/fzy-lua-native", "nixprime/cpsm" },
  config = function()
    require("plugins.wilder").setup()
  end,
  -- run = ":UpdateRemotePlugins",
  disable = false,
}

M.setup = function()
  local wilder = require "wilder"
  wilder.setup { modes = { ":", "/", "?" } }

  wilder.set_option("pipeline", {
    wilder.branch(
      wilder.python_file_finder_pipeline {
        file_command = function(_, arg)
          if string.find(arg, ".") ~= nil then
            return { "fd", "-tf", "-H" }
          else
            return { "fd", "-tf" }
          end
        end,
        dir_command = { "fd", "-td" },
        filters = { "cpsm_filter" },
      },
      wilder.substitute_pipeline {
        pipeline = wilder.python_search_pipeline {
          skip_cmdtype_check = 1,
          pattern = wilder.python_fuzzy_pattern {
            start_at_boundary = 0,
          },
        },
      },
      wilder.cmdline_pipeline {
        fuzzy = 2,
        fuzzy_filter = wilder.lua_fzy_filter(),
      },
      {
        wilder.check(function(_, x)
          return x == ""
        end),
        wilder.history(),
      },
      wilder.python_search_pipeline {
        pattern = wilder.python_fuzzy_pattern {
          start_at_boundary = 0,
        },
      }
    ),
  })

  local highlighters = {
    wilder.pcre2_highlighter(),
    wilder.lua_fzy_highlighter(),
  }

  local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
    border = "rounded",
    winblend = 20,
    empty_message = wilder.popupmenu_empty_message_with_spinner(),
    highlighter = highlighters,
    highlights = {
      -- accent = wilder.make_hl("WilderAccent", "WildMenu", {
      --   { a = 1 },
      --   { a = 1 },
      --   {
      --     foreground = "#ca72e4",
      --     -- background = "",
      --   },
      -- }),
      accent = "WildMenu",
      border = "Normal",
      default = "Normal",
    },
    left = {
      " ",
      wilder.popupmenu_devicons(),
      wilder.popupmenu_buffer_flags {
        flags = " a + ",
        icons = { ["+"] = "", a = "", h = "" },
      },
    },
    right = {
      " ",
      -- wilder.popupmenu_scrollbar(),
    },
  })

  ---@diagnostic disable-next-line: unused-local
  local wildmenu_renderer = wilder.wildmenu_renderer {
    highlighter = highlighters,
    highlights = {
      accent = "WildMenu",
      border = "Normal",
      default = "Normal",
      separator = "Delimiter",
    },
    separator = " · ",
    left = { " ", wilder.wildmenu_spinner(), " " },
    right = { " ", wilder.wildmenu_index() },
  }

  wilder.set_option(
    "renderer",
    wilder.renderer_mux {
      [":"] = popupmenu_renderer,
      ["/"] = wildmenu_renderer,
      substitute = wildmenu_renderer,
      -- ["/"] = popupmenu_renderer,
      -- substitute = popupmenu_renderer,
    }
  )
end

return M
