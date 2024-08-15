-- import lspconfig
local lspconfig = require('lspconfig')
capabilities = require("cmp_nvim_lsp").default_capabilities()

--
-- *** Lua ***
--

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

--
-- *** Java ***
--

local on_attach = function(client, bufnr)
  --local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  --local opts = { noremap = true, silent = true }
  local jdtls = require('jdtls')

  -- *** Additional commands specific to jdtls ***

  -- Organize imports
  vim.api.nvim_create_user_command('LspOrganizeImports', function()
    jdtls.organize_imports()
  end, {})

  -- Extract variable
  vim.api.nvim_create_user_command('LspExtractVariable', function()
    jdtls.extract_variable()
  end, {})

  -- Extract method
  vim.api.nvim_create_user_command('LspExtractMethod', function()
    jdtls.extract_method()
  end, {})

end

lspconfig.jdtls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.cmd [[
  autocmd FileType java setlocal shiftwidth=4 tabstop=4
  autocmd FileType java lua require('jdtls').start_or_attach({cmd = {'jdtls'}})
]]

--
-- *** Rust ***
--

lspconfig.rust_analyzer.setup({})

-- This plugin automatically sets up nvim-lspconfig for rust_analyzer for you,
-- so don't do that manually, as it causes conflicts.
local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.api.nvim_create_user_command("RustHoverActions", function()
        rt.hover_actions.hover_actions()
      end, {})
      -- Code action groups
      vim.api.nvim_create_user_command("RustCodeActionGroup", function()
        rt.code_action_group.code_action_group()
      end, {})
    end,
  },
})

--
-- *** Go ***
--

lspconfig.gopls.setup({
  settings = {
    cmd = { "gopls" },
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  capabilities = capabilities,
})

--
-- *** Python ***
--

lspconfig.basedpyright.setup({
  capabilities = capabilities,
})

lspconfig.ruff.setup({
  capabilities = capabilities,
})

--
-- *** Ruby ***
--

lspconfig.ruby_lsp.setup({
  capabilities = capabilities,
})

--
-- *** Other ***
--

lspconfig.bashls.setup({
  capabilities = capabilities,
})

lspconfig.dockerls.setup({
  capabilities = capabilities,
})

lspconfig.sqlls.setup({
  capabilities = capabilities,
})

lspconfig.terraformls.setup({
  capabilities = capabilities,
})

lspconfig.yamlls.setup({
  capabilities = capabilities,
})

-- *** Markdown ***
require('glow').setup({
  --install_path = "~/.local/bin", -- default path for installing glow binary
  pager = true,
  width = 130,
  height = 140,
  width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
  height_ratio = 0.7,
})
