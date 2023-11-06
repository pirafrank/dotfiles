-- Pull in the wezterm API
local wezterm = require 'wezterm'
local action = wezterm.action

-- This table will hold the launch menu entries
local launch_menu = {}

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- BELOW THIS LINE is where you actually apply your config choices

config.automatically_reload_config = true
config.show_update_window = true

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'Configuration reloaded!', nil, 3000)
end)

config.term = 'xterm-256color'

-- default shell to launch
-- default to user's shell on *nix, explicitly set on Windows.
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
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

----------------
-- appearance --
----------------

-- config.font = wezterm.font 'MesloLGM NF'
config.font = wezterm.font_with_fallback {
  'MesloLGM NF',
  'JetBrains Mono',
  'Courier New'
}
config.font_size = 10.0

-- change the color scheme:
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

-----------------
-- launch menu --
-----------------

local nix_menu_entries = {
  {
    label = 'top',
    args = { 'top' },
  },
  {
    label = 'ctop - Container top',
    args = { 'ctop' },
  },
  {
    label = 'lazydocker',
    args = { 'lazydocker' },
  },
  {
    label = 'dry - Docker dashboard',
    args = { 'dry' },
  },
  {
    label = 'kdash - Kubernetes dashboard',
    args = { 'kdash' },
  },
}
-- windows only entries
local windows_menu_entries = {
  {
    label = 'WSL (default distro)',
    args = { 'wsl.exe' }
  },
  {
    label = 'PowerShell 7',
    args = { 'C:/Program Files/PowerShell/7/pwsh.exe' },
  },
  {
    label = 'Git bash',
    args = { 'C:/Program Files/Git/bin/bash.exe', '--login' },
  },
  {
    label = 'Windows PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  },
  {
    label = 'top',
    args = { 'wsl.exe', '-d', 'Ubuntu-20.04', 'sh', '-c', 'exec top' }
  },
  {
    label = 'ctop - Container top',
    args = { 'wsl.exe', '-d', 'Ubuntu-20.04', 'sh', '-c', 'exec ctop' }
  },
  {
    label = 'lazydocker',
    args = { 'wsl.exe', '-d', 'Ubuntu-20.04', 'sh', '-c', 'exec lazydocker' }
  },
  {
    label = 'dry - Docker dashboard',
    args = { 'wsl.exe', '-d', 'Ubuntu-20.04', 'sh', '-c', 'exec dry' }
  },
  {
    label = 'kdash - Kubernetes dashboard',
    args = { 'wsl.exe', '-d', 'Ubuntu-20.04', 'kdash' }
  },
}
-- populate launch_menu table
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  for _, entry in ipairs(windows_menu_entries) do
    table.insert(launch_menu, entry)
  end
else
  for _, entry in ipairs(nix_menu_entries) do
    table.insert(launch_menu, entry)
  end
end
-- finally set launch_menu into config
config.launch_menu = launch_menu

-----------------
-- keybindings --
-----------------

-- disabling default, avoid conflicts with mine
config.disable_default_key_bindings = true

config.keys = {
  --
  -- leader key not set, not to conflict with vim
  -- https://wezfurlong.org/wezterm/config/keys.html#leader-key
  --

  -- reload config
  {
    key = 'r',
    mods = 'CTRL|SHIFT',
    action = action.ReloadConfiguration,
  },  
  -- CTRL-SHIFT-d activates the (interactive) debug tab
  { key = 'D', mods = 'CTRL', action = action.ShowDebugOverlay },

  -- paste from the clipboard
  { key = 'v', mods = 'CTRL', action = action.PasteFrom 'Clipboard' },
  -- copy to clipboard AND primary selection (X11)
  { key = 'C', mods = 'CTRL', action = action.CopyTo 'ClipboardAndPrimarySelection' },
  --
  -- ** WINDOWS (actual windows, not that Windows) **
  --
  { key = 'n', mods = 'SHIFT|CTRL', action = action.SpawnWindow },
  --
  -- ** TABS **
  --
  -- close current tab
  {
    key = 'W',
    mods = 'CTRL',
    action = action.CloseCurrentTab { confirm = true },
  },
  -- open new tab
  {
    key = 'T',
    mods = 'CTRL',
    --action = action.SpawnTab 'DefaultDomain',
    action = action.SpawnTab 'CurrentPaneDomain',
  },
  -- move among tabs
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = action.ActivateTabRelative(-1)
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = action.ActivateTabRelative(1)
  },
  { key = 'L', mods = 'CTRL', action = action.ShowTabNavigator },
  --
  -- ** PANES **
  -- splits
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '_',
    mods = 'CTRL|SHIFT',
    action = action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- move among panes
  {
    key = 'LeftArrow',
    mods = 'CTRL|ALT',
    action = action.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|ALT',
    action = action.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|ALT',
    action = action.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|ALT',
    action = action.ActivatePaneDirection 'Down',
  },
  -- more keybindings
  {
    key = 'P',
    mods = 'CTRL',
    action = action.ActivateCommandPalette,
  },
}

--------------------
-- mouse bindings --
--------------------

-- keep defaults
config.disable_default_mouse_bindings = false

-- do not pass click on unfocused window to below pane
config.swallow_mouse_click_on_window_focus = true

config.mouse_bindings = {
  -- paste with right click
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(action.PasteFrom 'Clipboard', pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(action.ClearSelection, pane)
      end
    end)
  },
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    --action = action.CompleteSelection 'ClipboardAndPrimarySelection',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(action.CompleteSelection 'ClipboardAndPrimarySelection', pane)
      else
        window:perform_action(action.ClearSelection, pane)
      end
    end)
  },
  -- ...and disable the 'Down' event
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(action.ClearSelection, pane)
      else
        window:perform_action(action.Nop, pane)
      end
    end)
  },
  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = action.OpenLinkAtMouseCursor,
  },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = action.Nop,
  },
}

-- and finally, return the configuration to wezterm
return config
