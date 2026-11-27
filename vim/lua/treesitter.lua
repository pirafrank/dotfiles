local parsers = {
  'bash',
  'c',
  'cpp',
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

  -- The main branch ships its queries in <plugin>/runtime/queries, which vim-plug
  -- doesn't add to the runtimepath. Without this, parsers load but have no
  -- highlights.scm (e.g. yaml loses highlighting).
  for _, dir in ipairs(vim.api.nvim_get_runtime_file('parser/yaml.so', true)) do
    local runtime = vim.fs.dirname(vim.fs.dirname(dir)) .. '/runtime'
    if vim.uv.fs_stat(runtime) then
      vim.opt.runtimepath:prepend(runtime)
    end
  end

  -- Install missing parsers (no-op for ones already installed). Compiling needs
  -- the tree-sitter CLI: `cargo install tree-sitter-cli`. Updates happen via :TSUpdate.
  if vim.fn.executable('tree-sitter') == 1 then
    require('nvim-treesitter').install(parsers)
  end

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
