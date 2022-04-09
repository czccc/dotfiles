local M = {}

M.colorscheme = "default"

M.colors = {
  -- one dark cool colors
  cool = {
    black = "#151820",
    bg0 = "#242b38",
    bg1 = "#2d3343",
    bg2 = "#343e4f",
    bg3 = "#363c51",
    bg_d = "#1e242e",
    bg_blue = "#6db9f7",
    bg_yellow = "#f0d197",
    fg = "#a5b0c5",
    purple = "#ca72e4",
    green = "#97ca72",
    orange = "#d99a5e",
    blue = "#5ab0f6",
    yellow = "#ebc275",
    cyan = "#4dbdcb",
    red = "#ef5f6b",
    grey = "#546178",
    light_grey = "#7d899f",
    dark_cyan = "#25747d",
    dark_red = "#a13131",
    dark_yellow = "#9a6b16",
    dark_purple = "#8f36a9",
    diff_add = "#303d27",
    diff_delete = "#3c2729",
    diff_change = "#18344c",
    diff_text = "#265478",
  },
}

M.styles = {}

M.links = {}

M.define_styles = function(name, style)
  M.styles[name] = style
  local style_str = ""
  for k, v in pairs(style) do
    style_str = style_str .. " " .. k .. "=" .. v
  end
  vim.cmd("highlight! " .. name .. style_str)
end

M.define_links = function(src, dst)
  M.links[src] = dst
  vim.cmd("highlight! link " .. src .. " " .. dst)
end

M.setup_colorscheme = function()
  vim.g.colors_name = M.colorscheme
  vim.cmd("colorscheme " .. M.colorscheme)
end

M.setup_highlights = function()
  for name, style in pairs(M.styles) do
    local style_str = ""
    for k, v in pairs(style) do
      style_str = style_str .. " " .. k .. "=" .. v
    end
    vim.cmd("highlight! " .. name .. style_str)
  end
  for src, dst in pairs(M.links) do
    vim.cmd("highlight! link " .. src .. " " .. dst)
  end
end

M.setup = function()
  require("core.autocmds").define_augroups {
    add_user_highlight = {
      {
        "ColorScheme",
        "*",
        "lua require('core.colors').setup_highlights()",
      },
    },
  }
  M.setup_colorscheme()
  M.setup_highlights()
end

return M
