-------------------------------
-- WezTerm config entrypoint --
-------------------------------

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- import my config packages
local home = os.getenv("HOME") or os.getenv("USERPROFILE")
local module_path = home .. "/dotfiles/terminals/wezterm/packages"
local is_windows = wezterm.target_triple:find("windows") ~= nil
if is_windows then
  module_path = module_path:gsub("/", "\\\\")
end
package.path = package.path .. ";" .. module_path .. "/?.lua"

local utils = require 'utils'

-- *************************************************************** --
-- BELOW THIS LINE is where you actually apply your config choices --
-- *************************************************************** --

-- automatically reload config when it changes on disk
config.automatically_reload_config = true

-- check for updates
config.show_update_window = true

------------
-- events --
------------

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'Configuration reloaded!', nil, 3000)
end)

-- show workspace name in upper right corner of the window
wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace() .. ' workspace  ')
end)

-----------
-- shell --
-----------

config.term = 'xterm-256color'

-- default shell to launch
-- default to user's shell on *nix, explicitly set on Windows.
if is_windows then
  config.default_prog = { 'C:\\Windows\\System32\\wsl.exe', '-d', 'Ubuntu-20.04', 'sh', '-c', 'cd $HOME;exec $SHELL' }
end

config.default_cwd = "$HOME"

----------
-- tabs --
----------

config.show_tabs_in_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true
config.mouse_wheel_scrolls_tabs = true
config.switch_to_last_active_tab_when_closing_tab = true

----------------
-- appearance --
----------------

local appearance_config = require 'appearance'
config = utils.merge_tables(config, appearance_config)

-----------------
-- launch menu --
-----------------

config.launch_menu = require 'launch_menu'

-----------------
-- keybindings --
-----------------

-- disabling default, avoid conflicts with mine
config.disable_default_key_bindings = true

config.keys = require 'keybindings'

--------------------
-- mouse bindings --
--------------------

-- disable defaults
config.disable_default_mouse_bindings = false

-- do not pass click on unfocused window to below pane
config.swallow_mouse_click_on_window_focus = true

config.mouse_bindings = require 'mouse_bindings'

------------------------------------------------------------
-- and finally, return the configuration to wezterm
------------------------------------------------------------

return config
