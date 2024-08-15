
-- Syntax highlighting
require'nvim-treesitter.configs'.setup {
  -- listed parsers that MUST always be installed
  ensure_installed = {
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
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have 'tree-sitter' CLI installed locally
  auto_install = true,

  ignore_install = {},

  highlight = {
    enable = true,
    disable = {},
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` ifou depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow downour editor, andou may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  -- Incremental selection based on the named nodes from the grammar
  incremental_selection = {
    enable = true,
  },

  -- Indentation based on treesitter for the = operator.
  -- NOTE: This is an experimental feature.
  indent = {
    enable = true,
  },

}

