--------------------
-- mouse bindings --
--------------------

local wezterm = require 'wezterm'
local action = wezterm.action

return {
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
