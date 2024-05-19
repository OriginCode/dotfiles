-- Pull in the wezterm API
local wezterm = require 'wezterm'

local merge_tables = function(first_table, second_table)
  for k, v in pairs(second_table) do
    first_table[k] = v
  end
  return first_table
end

local extract_tab_bar_colors_from_theme = function(theme_name)
  local wez_theme = wezterm.color.get_builtin_schemes()[theme_name]
  return {
    window_frame_colors = {
      active_titlebar_bg = wez_theme.background,
      inactive_titlebar_bg = wezterm.color.parse(wez_theme.background):darken(0.8),
    },
    tab_bar_colors = {
      inactive_tab_edge = wezterm.color.parse(wez_theme.background):darken(0.8),
      active_tab = {
        bg_color = wez_theme.brights[3],
        fg_color = wez_theme.background,
      },
      inactive_tab = {
        bg_color = wez_theme.background,
        fg_color = wez_theme.foreground,
      },
      inactive_tab_hover = {
        bg_color = wezterm.color.parse(wez_theme.background):lighten(0.1),
        fg_color = wezterm.color.parse(wez_theme.foreground):lighten(0.2),
      },
      new_tab = {
        bg_color = wez_theme.background,
        fg_color = wez_theme.foreground,
      },
      new_tab_hover = {
        bg_color = wez_theme.brights[3],
        fg_color = wez_theme.background,
      },
    },
  }
end

local tab_bar_theme = extract_tab_bar_colors_from_theme("Gruvbox Dark (Gogh)")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font = wezterm.font_with_fallback {
  "Sarasa Term TC",
  "Sarasa Term HC",
  "Sarasa Term SC",
  "Sarasa Term J",
  "Sarasa Term K",
  "Iosevka Nerd Font Propo"
}
config.font_size = 12.0
config.color_scheme = "Gruvbox Dark (Gogh)"
config.window_decorations = "RESIZE"
-- config.enable_tab_bar = false
config.window_background_opacity = 0.8
config.term = "wezterm"
-- config.default_prog = { '/usr/bin/zellij', 'a', '-c', 'main' }

config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = tab_bar_theme.tab_bar_colors,
}

config.unix_domains = {
  {
    name = 'unix',
  },
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
-- config.default_gui_startup_args = { 'connect', 'unix' }

-- and finally, return the configuration to wezterm
return config
