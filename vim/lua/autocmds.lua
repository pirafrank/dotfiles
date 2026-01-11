-- Create an autocmd group
local lsp_group = vim.api.nvim_create_augroup("LspGroup", { clear = true })

-- Create treesitter folding group
local ts_fold_group = vim.api.nvim_create_augroup("TreesitterFold", { clear = true })

-- Define the autocmd
vim.api.nvim_create_autocmd("CursorHold", {
  group = lsp_group,
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

-- Define the autocmd
vim.api.nvim_create_autocmd("BufRead", {
  group = lsp_group,
  pattern = "*",
  callback = function()
    if vim.fn.mode() == 'n' then
      vim.cmd("LspStart")
    end
  end,
})

-- Enable treesitter-based folding for supported languages
-- This uses the newer Neovim built-in vim.treesitter.foldexpr()
vim.api.nvim_create_autocmd({"FileType", "BufEnter", "BufWinEnter"}, {
  group = ts_fold_group,
  pattern = {
    "bash", "c", "cpp", "css", "dockerfile", "go", "graphql", "html",
    "java", "javascript", "jsx", "json", "lua", "markdown", "python",
    "rust", "scss", "tsx", "typescript", "vim", "vue", "yaml"
  },
  callback = function()
    -- Check if treesitter parser is available for this filetype
    local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
    if ok and parsers.has_parser() then
      vim.opt_local.foldmethod = "expr"
      -- Use Neovim's built-in treesitter foldexpr
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt_local.foldenable = true
      -- Set foldlevel high to start with all folds open
      vim.opt_local.foldlevel = 99
      -- Set minimum lines for a fold
      vim.opt_local.foldminlines = 1
    end
  end,
})
