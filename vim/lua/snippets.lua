-- Load personal snippets kept in the dotfiles repository so the same snippets
-- are available on every system where the repository is installed at ~/dotfiles.
local snippet_path = vim.fn.expand('~/dotfiles/lua/luasnippets')

require('luasnip.loaders.from_lua').lazy_load({
  paths = { snippet_path },
})

vim.api.nvim_create_user_command('LuaSnipEdit', function()
  require('luasnip.loaders').edit_snippet_files()
end, {
  desc = 'Edit a shared LuaSnip file for the current filetype',
  force = true,
})
