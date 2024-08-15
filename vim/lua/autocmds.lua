-- Create an autocmd group
local lsp_group = vim.api.nvim_create_augroup("LspGroup", { clear = true })

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
