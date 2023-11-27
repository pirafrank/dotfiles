----------------
-- workspaces --
----------------

local wezterm = require 'wezterm'
local defaults = require 'defaults'

local mux = wezterm.mux
local default_domain = defaults.default_domain

local workspaces = {}

function workspaces.fuzzypi(args)
  -- Set a workspace for fuzzypi on a current project
  -- Top pane is for the editor, bottom pane is for the build tool
  local project_dir = '~/Code/Rust/fuzzypi/fuzzypi-t2'
  local tab, build_pane, window = mux.spawn_window {
    workspace = 'fuzzypi',
    cwd = project_dir,
    args = args,
    domain = { DomainName = default_domain },
  }
  local editor_pane = build_pane:split {
    direction = 'Top',
    size = 0.6,
    cwd = project_dir,
  }
  -- may as well kick off a build in that pane
  build_pane:send_text 'cargo build\n'
end

return workspaces
