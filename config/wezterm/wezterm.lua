local wt = require("wezterm")
-- local wezterm = wt

local config = {
  default_prog = { "pwsh.exe" },
  launch_menu = {
    {
      args = { "zsh" },
    },
    {
      label = "Bash",
      args = { "bash", "-l" },
    },
  },
  color_scheme = "Dracula",
  -- window_decorations = "RESIZE",
  window_background_opacity = 0.97,
  window_padding = {
    left = 3,
    right = 3,
    top = 3,
    bottom = 3,
  },
  default_cursor_style = "BlinkingBar",
  window_frame = {
    font_size = 11.0,
    active_titlebar_bg = "#20222c",
    inactive_titlebar_bg = "#333333",
  },
  colors = {
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      -- (does not apply when fancy tab bar is in use)
      background = "#20222c",

      -- The active tab is the one that has focus in the window
      active_tab = {
        bg_color = "#20222c",
        fg_color = "#c0c0c0",
        intensity = "Normal",
        underline = "None",
        italic = false,
        strikethrough = false,
      },
      inactive_tab = {
        bg_color = "#20222c",
        fg_color = "#808080",
      },
      inactive_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,
      },
      new_tab = {
        bg_color = "#20222c",
        fg_color = "#808080",
      },
      new_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,
      },
    },
  },
  font_size = 11,
  font = wt.font_with_fallback({
    {
      family = "FiraCode NF",
      weight = "Medium",
    },
    {
      family = "SFMono NF",
      weight = "Medium",
    },
  }),
  font_rules = {
    {
      intensity = "Bold",
      font = wt.font("FiraCode NF", { weight = "Medium" }),
    },
    {
      italic = true,
      intensity = "Normal",
      font = wt.font("SFMono NF", { weight = "Medium", italic = true }),
    },
  },
}

local status_ok, win_config = pcall(require, "win")
if status_ok then
  print("aaa")
end

return config
