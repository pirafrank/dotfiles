--------------
-- defaults --
--------------

local utils = require 'utils'

local defaults = {}
defaults.nix = {}
defaults.win = {}

-- *nix entries
-- default to user's shell on *nix, explicitly set on Windows.
defaults.nix.default_prog = { os.getenv("SHELL") }
defaults.nix.default_domain = 'DefaultDomain'
defaults.nix.default_cwd = "$HOME"
defaults.nix.default_workspace = 'default'

-- Windows entries
defaults.win.default_prog = { 'zsh' }
defaults.win.default_domain = 'WSL:Ubuntu-20.04'
defaults.win.default_cwd = "$HOME"
defaults.win.default_workspace = 'default'


if utils.is_windows() then
  return defaults.win
else
  return defaults.nix
end
