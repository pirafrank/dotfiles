# Shared LuaSnip snippets

These snippets are loaded by Neovim directly from
`~/dotfiles/lua/luasnippets`, so committing this directory shares them across
systems.

- `all.lua` contains snippets available for every filetype.
- `<filetype>.lua` contains snippets for one filetype, such as `python.lua` or
  `rust.lua`.
- `<filetype>/*.lua` can split a large filetype collection across several
  files.

Each Lua file returns a list of snippets. LuaSnip makes constructors such as
`s` (snippet), `t` (text), `i` (insert node), `c` (choice node), and `f`
(function node) available inside these files.

For example, `python.lua` could contain:

```lua
return {
  s('def', {
    t('def '), i(1, 'function_name'), t('('), i(2), t({ '):', '    ' }),
    i(0, 'pass'),
  }),
}
```

Lua snippet files are reloaded when saved. Use `:LuaSnipEdit` to select and
open a snippet file associated with the current buffer's filetype.

## fpiracom Markdown snippets

`markdown/fpiracom.lua` contains the Jekyll constructs used by the fpiracom
blog:

|Trigger|Content|
|---|---|
|`frontmatter`|Complete post frontmatter with the current date|
|`postimage`|Markdown image using `site.baseurl`|
|`imageinclude`|`image.html` Liquid include with attribution fields|
|`gist`|GitHub Gist embed|
|`youtube`|YouTube embed|
|`vimeo`|Vimeo embed|
|`ted`|TED embed|
|`posturl`|Markdown link to another Jekyll post|
|`staticlink`|Jekyll link to a static file|
|`externallink`|External-data link with safe new-tab attributes|
