-----------------
-- keybindings --
-----------------

local wezterm = require 'wezterm'
local action = wezterm.action

local defaults = require 'defaults'
local workspace_functions = require 'workspaces'

return {
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
  -- rename tab
  {
    key = 'E',
    mods = 'CTRL',
    action = action.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Text = 'Enter name for the tab' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  -- move among tabs
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = action.ActivateTabRelative(-1)
  },
  -- list current tabs
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
  --
  -- ** WORKSPACES **
  --
  -- show launcher with workspaces
  {
    key = 'K', mods = 'CTRL', action = action.ShowLauncherArgs {
      flags = 'FUZZY|LAUNCH_MENU_ITEMS|TABS|WORKSPACES',
      title = 'Launcher',
    }
  },
  { key = 'm', mods = 'CTRL|ALT', action = action.SwitchWorkspaceRelative(1) },
  { key = 'n', mods = 'CTRL|ALT', action = action.SwitchWorkspaceRelative(-1) },
  {
    key = 'U',
    mods = 'CTRL',
    action = action.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Text = 'Enter name of new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          -- if line is empty, then switch to the default workspace
          if line == '' then
            line = defaults.default_workspace
          end
          -- get known workspaces
          local workspaces = wezterm.mux.get_workspace_names()
          -- create custom workspace from workspaces package if it is not already open
          if workspaces and not workspaces[line] and workspace_functions[line] then
            workspace_functions[line]()
          end
          -- switch to existing or create new workspace
          window:perform_action(
            action.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
}
