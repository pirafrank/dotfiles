----------------
-- workspaces --
----------------

return {
  {
    name = 'fpiracom',
    dirs = {
      os.getenv('HOME') .. '/Code/projects/fpiracom',
      os.getenv('HOME') .. '/Code/projects/fpiracom/_data',
      os.getenv('HOME') .. '/Code/projects/fpiracom/_posts',
      os.getenv('HOME') .. '/Code/projects/fpiracom/_drafts',
      os.getenv('HOME') .. '/Code/projects/fpiracom/pages',
      os.getenv('HOME') .. '/Code/projects/fpiracom/_includes'
    }
  }
}
