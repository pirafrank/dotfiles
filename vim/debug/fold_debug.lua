-- Debug script to check folding setup
-- Run this in nvim with :luafile ~/dotfiles/vim/lua/fold_debug.lua

print("=== Folding Debug Info ===")
print("")

-- Check current buffer settings
print("Current buffer fold settings:")
print("  foldmethod: " .. vim.wo.foldmethod)
print("  foldexpr: " .. vim.wo.foldexpr)
print("  foldenable: " .. tostring(vim.wo.foldenable))
print("  foldlevel: " .. vim.wo.foldlevel)
print("")

-- Check current filetype
print("Current filetype: " .. vim.bo.filetype)
print("")

-- Check if treesitter parser is available
local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
if ok then
  local has_parser = parsers.has_parser()
  print("Treesitter parser available: " .. tostring(has_parser))
  if has_parser then
    local lang = parsers.get_buf_lang()
    print("Treesitter language: " .. (lang or "none"))
  end
else
  print("ERROR: Could not load nvim-treesitter.parsers")
end
print("")

-- Check installed parsers
local ok2, parsers_list = pcall(vim.api.nvim_get_runtime_file, 'parser/*.so', true)
if ok2 then
  print("Installed treesitter parsers:")
  for _, parser in ipairs(parsers_list) do
    local lang = parser:match("parser/(%w+)%.so$")
    if lang then
      print("  - " .. lang)
    end
  end
else
  print("Could not get parser list")
end
print("")

print("=== End Debug Info ===")

