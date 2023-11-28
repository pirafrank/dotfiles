----------------
-- workspaces --
----------------

local wezterm = require 'wezterm'
local defaults = require 'defaults'
local utils = require 'utils'

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

-- merge workspaces into one table
-- check if workspaces_hidden.lua exists:
-- if it does, merge it with workspaces
-- if it doesn't, just return workspaces
local ws = {}
local ok, hidden = pcall(require, 'workspaces_hidden')
if ok then
  ws = utils.merge_tables(workspaces, hidden)
end
return ws
