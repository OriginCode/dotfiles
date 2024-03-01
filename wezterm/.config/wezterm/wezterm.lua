-- Pull in the wezterm API
local wezterm = require 'wezterm'

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
}
config.font_size = 14.0
config.color_scheme = "Gruvbox Dark (Gogh)"
config.window_decorations = "NONE"
config.enable_tab_bar = false
-- config.window_background_opacity = 0.95
config.term = "wezterm"
-- config.default_prog = { '/usr/bin/zellij', 'a', '-c', 'main' }

-- and finally, return the configuration to wezterm
return config
