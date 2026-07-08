local parsers = {
  'bash',
  'c',
  'css',
  'dockerfile',
  'go',
  'gomod',
  'graphql',
  'html',
  'kdl',
  'java',
  'javascript',
  'markdown',
  'markdown_inline',
  'regex',
  'json',
  'lua',
  'python',
  'rust',
  'scss',
  'tsx',
  'typescript',
  'vim',
  'vue',
  'yaml',
}

local filetypes = {
  'bash',
  'c',
  'cpp',
  'css',
  'dockerfile',
  'go',
  'graphql',
  'html',
  'java',
  'javascript',
  'javascriptreact',
  'json',
  'lua',
  'markdown',
  'python',
  'rust',
  'scss',
  'typescript',
  'typescriptreact',
  'vim',
  'vue',
  'yaml',
}

local ok, treesitter = pcall(require, 'nvim-treesitter')

if ok and type(treesitter.install) == 'function' then
  -- nvim-treesitter main branch for Neovim 0.12+: parsers and queries only.
  treesitter.setup()

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
    pattern = filetypes,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
else
  -- Backward-compatible path for the legacy master branch during plugin updates.
  require('nvim-treesitter.configs').setup {
    ensure_installed = parsers,
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  }
end
