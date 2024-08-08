--------------
-- defaults --
--------------

local utils = require 'utils'

local defaults = {}
defaults.nix = {}
defaults.win = {}

-- *nix entries
-- default to user's shell on *nix, explicitly set on Windows.
defaults.nix.default_prog = { '/usr/bin/env', 'zsh' }
defaults.nix.default_domain = 'local'
defaults.nix.default_cwd = os.getenv('HOME')
defaults.nix.default_workspace = 'default'

-- Windows entries
defaults.win.default_prog = { 'zsh' }
defaults.win.default_domain = 'WSL:Ubuntu-20.04'
defaults.win.default_cwd = "~"
defaults.win.default_workspace = 'default'


if utils.is_windows() then
  return defaults.win
else
  return defaults.nix
end
