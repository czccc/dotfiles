local M = {}

M.colorscheme = "default"

M.colors = {}

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
