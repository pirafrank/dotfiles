
-- *** Mason ***
-- LSP management
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
  --  "lua_ls",
    "rust_analyzer"
  },
})

-- After setting up mason-lspconfig you may set up servers via lspconfig
-- require("lspconfig").lua_ls.setup {}
require("lspconfig").rust_analyzer.setup {}


-- *** Rust ***

-- This plugin automatically sets up nvim-lspconfig for rust_analyzer for you,
-- so don't do that manually, as it causes conflicts.
local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
