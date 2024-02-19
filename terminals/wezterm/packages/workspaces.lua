----------------
-- workspaces --
----------------

local wezterm = require 'wezterm'
local defaults = require 'defaults'
local workspace_envs = require 'workspace_envs'

local mux = wezterm.mux
local default_domain = defaults.default_domain

local workspaces = {}

local function add_workspace_functions(envs)
  for i, env in ipairs(envs) do
    local workspaceName = env.name
    local workspaceDirs = env.dirs
    -- add function to 'workspaces' var
    workspaces[workspaceName] = function(args)
      -- spawn new window with multiple tabs
      local tab, pane, window = mux.spawn_window {
        workspace = workspaceName,
        cwd = workspaceDirs[1],
        args = args,
        domain = { DomainName = default_domain },
      }
      tab:set_title('root')
      for j = 2, #workspaceDirs do
        local dir = workspaceDirs[j]
        local new_tab, new_pane, new_window = window:spawn_tab {
          cwd = dir,
          domain = { DomainName = default_domain },
        }
        -- split dir string by '/' and get last
        local title = dir:match '[^/]+$'
        new_tab:set_title(title)
      end
      -- activate first tab
      tab:activate()
    end
  end
end

-- ************************************
-- add custom workspace functions below
-- ************************************

function workspaces.fuzzypi(args)
  -- Set a workspace for fuzzypi on a current project
  -- Top pane is for the editor, bottom pane is for the build tool
  local project_dir = '~/Code/Workspaces/Rust/fuzzypi/fuzzypi-t2'
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

-- ***************************
-- DO NOT EDIT BELOW THIS LINE
-- ***************************

-- adding known workspace envs
add_workspace_functions(workspace_envs)

-- check if workspaces_hidden.lua exists:
-- if it does, add workspaces
-- if it doesn't, don't do anything
local ok, hidden = pcall(require, 'workspaces_hidden')
if ok then
  add_workspace_functions(hidden)
end
return workspaces
