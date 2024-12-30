----------------
-- workspaces --
----------------

-- set home path so that it works on both Windows and *nix
local defaults = require 'defaults'
local home = defaults.default_cwd

return {
  {
    name = 'fpiracom',
    dirs = {
      home .. '/Code/projects/fpiracom',
      home .. '/Code/projects/fpiracom/_data',
      home .. '/Code/projects/fpiracom/_posts',
      home .. '/Code/projects/fpiracom/_drafts',
      home .. '/Code/projects/fpiracom/pages',
      home .. '/Code/projects/fpiracom/_includes'
    }
  },
  {
    name = 'dotfiles',
    dirs = {
      home .. '/dotfiles',
      home .. '/dotfiles',
      home .. '/dotfiles'
    }
  },
  {
    name = 'yazi',
    dirs = {
      home .. '/Code/projects/what-size.yazi',
      home .. '/dotfiles/yazi',
      home .. '/.config/yazi',
      home .. '/.config/yazi/plugins',
      home .. '/dotfiles/yazi'
    }
  }
}
