-- Get capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

--
-- *** Lua ***
--

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

vim.lsp.enable('lua_ls')

--
-- *** Java ***
--

local on_attach = function(client, bufnr)
  local jdtls = require('jdtls')

  -- *** Additional commands specific to jdtls ***

  -- Organize imports
  vim.api.nvim_create_user_command('LspOrganizeImports', function()
    jdtls.organize_imports()
  end, { desc = "Lsp: Organize imports" })

  -- Extract variable
  vim.api.nvim_create_user_command('LspExtractVariable', function()
    jdtls.extract_variable()
  end, { desc = "Lsp: Extract variable" })

  -- Extract method
  vim.api.nvim_create_user_command('LspExtractMethod', function()
    jdtls.extract_method()
  end, { desc = "Lsp: Extract method" })

end

vim.lsp.config('jdtls', {
  cmd = { 'jdtls' },
  root_markers = { 'gradlew', 'mvnw', '.git' },
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.cmd [[
  autocmd FileType java setlocal shiftwidth=4 tabstop=4
  autocmd FileType java lua vim.lsp.enable('jdtls')
]]

--
-- *** Rust ***
--

-- This plugin automatically sets up nvim-lspconfig for rust_analyzer for you,
-- so don't do that manually, as it causes conflicts.
vim.g.rustaceanvim = {
  -- DAP (Debugger) configuration
  dap = {
    adapter = require('rustaceanvim.config').get_codelldb_adapter(
      vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
    ),
  },
  server = {
    on_attach = function(client, bufnr)
      -- Hover actions
      vim.api.nvim_create_user_command("RustHoverActions", function()
        vim.cmd.RustLsp({ 'hover', 'actions' })
      end, { desc = "Rust: Hover Actions" })
      -- Code action groups
      vim.api.nvim_create_user_command("RustCodeActionGroup", function()
        vim.cmd.RustLsp('codeAction')
      end, { desc = "Rust: Code Action groups" })
    end,
    default_settings = {
      ['rust-analyzer'] = {},
    },
  },
}

--
-- *** Go ***
--

vim.lsp.config('gopls', {
  cmd = { "gopls" },
  root_markers = { 'go.work', 'go.mod', '.git' },
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})

vim.lsp.enable('gopls')

--
-- *** Python ***
--

vim.lsp.config('basedpyright', {
  cmd = { 'basedpyright-langserver', '--stdio' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  capabilities = capabilities,
})

vim.lsp.enable('basedpyright')

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  capabilities = capabilities,
})

vim.lsp.enable('ruff')

--
-- *** Ruby ***
--

vim.lsp.config('ruby_lsp', {
  cmd = { 'ruby-lsp' },
  root_markers = { 'Gemfile', '.git' },
  capabilities = capabilities,
})

vim.lsp.enable('ruby_lsp')

--
-- *** Other ***
--

vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  root_markers = { '.git' },
  capabilities = capabilities,
})

vim.lsp.enable('bashls')

vim.lsp.config('dockerls', {
  cmd = { 'docker-langserver', '--stdio' },
  root_markers = { 'Dockerfile', '.git' },
  capabilities = capabilities,
})

vim.lsp.enable('dockerls')

vim.lsp.config('sqlls', {
  cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
  root_markers = { '.git' },
  capabilities = capabilities,
})

vim.lsp.enable('sqlls')

vim.lsp.config('terraformls', {
  cmd = { 'terraform-ls', 'serve' },
  root_markers = { '.terraform', '.git' },
  capabilities = capabilities,
})

vim.lsp.enable('terraformls')

vim.lsp.config('yamlls', {
  cmd = { 'yaml-language-server', '--stdio' },
  root_markers = { '.git' },
  capabilities = capabilities,
})

vim.lsp.enable('yamlls')

-- *** Markdown ***
require('glow').setup({
  --install_path = "~/.local/bin", -- default path for installing glow binary
  pager = true,
  width = 130,
  height = 140,
  width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
  height_ratio = 0.7,
})
