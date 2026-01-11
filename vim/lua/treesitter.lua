-- Treesitter configuration for the latest nvim-treesitter API
-- This configuration is compatible with nvim-treesitter v2.0+

local ts = require('nvim-treesitter')

-- Setup nvim-treesitter (optional, only needed if you want to change install_dir)
-- Default install_dir is vim.fn.stdpath('data') .. '/site'
ts.setup({
  -- Directory to install parsers and queries to
  -- install_dir = vim.fn.stdpath('data') .. '/site',
})

-- List of parsers to install
local parsers = {
  'bash',
  'c',
  'css',
  'dockerfile',
  'go',
  'gomod',
  'graphql',
  'html',
  'java',
  'javascript',
  'json',
  'kdl',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'rust',
  'scss',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
  'yaml',
}

-- Install parsers asynchronously
-- This will only install parsers that are not already installed
ts.install(parsers)

-- Enable treesitter-based folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false  -- Start with folds open

vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'
