----------------
-- appearance --
----------------

local wezterm = require 'wezterm'

local config = {}

-- Setting the front end to 'OpenGL' will enable GPU rendering
-- docs: https://wezfurlong.org/wezterm/config/lua/config/front_end.html?h=front_end
config.front_end = 'OpenGL'
-- Setting the front end to 'Software' will disable GPU rendering
--config.front_end = 'Software'

-- config.font = wezterm.font 'MesloLGM Nerd Font'
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'JetBrains Mono',
  'MesloLGM Nerd Font',
  'Courier New'
}
config.font_size = 10.0

-- change the color scheme:
-- list of color schemes available here:
--   https://wezfurlong.org/wezterm/colorschemes/index.html
--config.color_scheme = 'OneHalfDark'
config.color_scheme = 'Dracula'
--config.color_scheme = 'ChallengerDeep'

--config.window_background_opacity = 0.95
config.window_background_opacity = 1.0

-- Window padding (matching Rio's padding-y = [5, 5])
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- Set the initial window size (Rio uses 960x600)
config.initial_cols = 130
config.initial_rows = 34

-- Disable cursor blinking
config.default_cursor_style = 'SteadyBlock'

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
