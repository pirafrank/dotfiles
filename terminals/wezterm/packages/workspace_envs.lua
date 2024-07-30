----------------
-- workspaces --
----------------

-- set home path so that it works on both Windows and *nix
local home = os.getenv("HOME") or os.getenv("USERPROFILE")

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
  }
}
