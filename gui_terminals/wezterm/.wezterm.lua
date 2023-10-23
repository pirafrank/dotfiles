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
config.color_scheme = 'OneHalfDark'
-- config.font = wezterm.font 'MesloLGM NF'
config.font = wezterm.font_with_fallback {
  'MesloLGM NF',
  'JetBrains Mono',
  'Courier New'
}
config.font_size = 10.0


config.default_prog = { 'C:\\Windows\\System32\\wsl.exe', '-d', 'Ubuntu-20.04', 'sh', '-c', 'cd $HOME;exec $SHELL' }
config.default_cwd = "$HOME"


-- and finally, return the configuration to wezterm
return config
