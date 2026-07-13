-- Snippets in all.lua are available for every filetype.
return {
  s(
    { trig = 'date', name = 'Current date', dscr = 'Insert the current local date' },
    f(function()
      return os.date('%Y-%m-%d')
    end, {})
  ),
}
