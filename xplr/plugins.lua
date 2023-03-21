--[[

  *** PLUGINS HERE! ***

  add plugins to load the table below.
  they will be loaded only if their dir exists in ~/.config/xplr/plugins.

--]]

return {
  -- { "some_module_without_setup_args", "https://git_repo_url_of_module" },
  -- { "some_module_with_setup_args", "https://git_repo_url_of_module",
  --    { arg1 = "some value", arg2 = "something else" }
  -- }

  -- git clone https://github.com/prncss-xyz/icons.xplr ~/.config/xplr/plugins/icons
  {
    "icons",
    "https://github.com/prncss-xyz/icons.xplr"
  },

  --[[
  {
    "material-landscape2",
    "https://github.com/sayanarijit/material-landscape2.xplr",
    { keep_default_layout = true }
  },
  --]]

  {
    "zentable",
    "https://github.com/sayanarijit/zentable.xplr"
  },

  {
    "tri-pane",
    "https://github.com/sayanarijit/tri-pane.xplr",
    {
      layout_key = "T", -- In switch_layout mode
      as_default_layout = true,
      left_pane_width = { Percentage = 15 },
      middle_pane_width = { Percentage = 50 },
      right_pane_width = { Percentage = 35 },
      left_pane_renderer = custom_function_to_render_left_pane,
      right_pane_renderer = custom_function_to_render_right_pane
    }
  }
}
