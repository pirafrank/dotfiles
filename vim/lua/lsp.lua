
-- *** Mason ***
-- Manage LSP, DAP, linters and formatters.
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "↓",
      package_uninstalled = "◌"
    }
  }
})
require("mason-lspconfig").setup({
  ensure_installed = {
    --"gopls",
    --"lua_ls",
    --"ruby_lsp",
    --"rust_analyzer"
  },
})

-- vim diagnostics
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
-- disable in-line diagnostics
-- we have icons in the gutter and floating pane for cursor over line
vim.diagnostic.config({virtual_text = false})

-- After setting up mason-lspconfig you may set up servers via lspconfig,
-- so this file needs to be required before setting up language servers.

local tsb = require('telescope.builtin')

-- Toggle virtual text on and off
vim.api.nvim_create_user_command('LspToggleVirtualText', function()
  local config = vim.diagnostic.get_config()
  config.virtual_text = not config.virtual_text
  vim.diagnostic.set_config(config)
end, { desc = "Lsp: Toggle virtual text" })

-- Go to declaration
vim.api.nvim_create_user_command('LspGoToDeclaration', function()
  vim.lsp.buf.declaration()
end, { desc = "Go to declaration" })

-- Go to type definition
vim.api.nvim_create_user_command('LspGoToTypeDefinition', function()
  tsb.lsp_type_definitions()
end, { desc = "Go to type definition" })

-- Go to implementation
vim.api.nvim_create_user_command('LspGoToImplementation', function()
  vim.lsp.buf.implementation()
end, { desc = "Go to implementation" })

-- List and search document symbols
vim.api.nvim_create_user_command('LspDocumentSymbols', function()
  tsb.lsp_document_symbols()
end, { desc = "List and search document symbols" })

-- *** Seach commands ***

-- Find references
vim.api.nvim_create_user_command('LspFindReferences', function()
  tsb.lsp_references()
end, { desc = "Find references" })

-- Workspace symbol search
vim.api.nvim_create_user_command('LspSearchWorkspaceSymbols', function()
  vim.ui.input({ prompt = 'Enter query: ' }, function(query)
    if query then
      tsb.lsp_workspace_symbols({ query = query })
    end
  end)
end, { desc = "Search symbol in Workspace" })

-- *** Diagnostics commands ***

-- Show all diagnostics
vim.api.nvim_create_user_command('LspDiagnostics', function()
  tsb.diagnostics()
end, { desc = "Show all diagnostics" })

-- Show inline diagnostics
vim.api.nvim_create_user_command('LspInLineDiagnostics', function()
  vim.diagnostic.open_float()
end, { desc = "Show in-line diagnostics" })

-- Go to next diagnostic
vim.api.nvim_create_user_command('LspDiagGoToNext', function()
  vim.diagnostic.goto_next()
end, { desc = "Go to next diagnostic message" })

-- Go to previous diagnostic
vim.api.nvim_create_user_command('LspDiagGoToPrev', function()
  vim.diagnostic.goto_prev()
end, { desc = "Go to previous diagnostic message" })

-- *** Refactoring commands ***

-- Rename symbol
vim.api.nvim_create_user_command('LspRenameSymbol', function()
  vim.lsp.buf.rename()
end, { desc = "Rename symbol" })

-- *** 'Show info' commands ***

-- Show documentation
vim.api.nvim_create_user_command('LspHover', function()
  vim.lsp.buf.hover()
end, { desc = "Show documentation" })

-- Show signature help
vim.api.nvim_create_user_command('LspSignatureHelp', function()
  vim.lsp.buf.signature_help()
end, { desc = "Show signature help" })

-- Inline code annotations
vim.api.nvim_create_user_command('LspCodeLens', function()
  vim.lsp.codelens.refresh()
  vim.lsp.codelens.run()
end, { desc = "Get in-line code annotations" })

-- *** Action commands ***

-- Quick fix
vim.api.nvim_create_user_command('LspActions', function()
  vim.lsp.buf.code_action()
end, { desc = "Quick fix" })

-- Format document
vim.api.nvim_create_user_command('LspFormatDocument', function()
  -- using the following because vim.lsp.buf.formatting() is deprecated.
  vim.lsp.buf.format { async = true }
end, { desc = "Format document" })
