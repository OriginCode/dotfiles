-- Pull in the wezterm API
local wezterm = require 'wezterm'

local extract_tab_bar_colors_from_theme = function(theme_name)
  local wez_theme = wezterm.color.get_builtin_schemes()[theme_name]
  return {
    window_frame_colors = {
      active_titlebar_bg = wez_theme.background,
      inactive_titlebar_bg = wezterm.color.parse(wez_theme.background):darken(0.8),
    },
    tab_bar_colors = {
      background = wez_theme.background,
      inactive_tab_edge = wezterm.color.parse(wez_theme.background):darken(0.8),
      active_tab = {
        bg_color = wez_theme.brights[4],
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
        bg_color = wez_theme.brights[4],
        fg_color = wez_theme.background,
      },
    },
  }
end


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
config.color_scheme = "Gruvbox (Gogh)"
local tab_bar_theme = extract_tab_bar_colors_from_theme(config.color_scheme)
config.window_decorations = "NONE"
-- config.enable_tab_bar = false
function opaque_when_fullscreen(window)
  local window_dims = window:get_dimensions()
  local overrides = window:get_config_overrides() or {}

  if window_dims.is_full_screen then
    overrides.window_background_opacity = 1.0
  else
    overrides.window_background_opacity = 0.9
  end
  window:set_config_overrides(overrides)
end
wezterm.on('window-resized', function(window, pane)
  opaque_when_fullscreen(window)
end)
wezterm.on('window-config-reloaded', function(window)
  opaque_when_fullscreen(window)
end)
config.term = "wezterm"
-- config.default_prog = { '/usr/bin/zellij', 'a', '-c', 'main' }

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.window_frame = tab_bar_theme.window_frame_colors
config.colors = {
  tab_bar = tab_bar_theme.tab_bar_colors,
}

-- config.enable_wayland = false
-- config.front_end = "WebGpu"

config.scrollback_lines = 100000

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
