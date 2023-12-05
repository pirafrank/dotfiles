----------------
-- appearance --
----------------

local wezterm = require 'wezterm'

local config = {}

-- config.font = wezterm.font 'MesloLGM Nerd Font'
config.font = wezterm.font_with_fallback {
  'MesloLGM Nerd Font',
  'JetBrains Mono',
  'Courier New'
}
config.font_size = 10.0

-- change the color scheme:
-- list of color schemes available here:
--   https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'OneHalfDark'

config.window_background_opacity = 0.95

-- Set the initial window size
config.initial_cols = 150
config.initial_rows = 38

-- config and use only visual bell
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 80,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 70,
}
config.colors = {
  visual_bell = '#afafaf',
}

return config
