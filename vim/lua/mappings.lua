
-- Set the keymap to open Telescope in find files
vim.api.nvim_set_keymap('n', '<C-p>', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })

-- Set the keymap to search buffers using Telescope
vim.api.nvim_set_keymap('n', '<C-b>', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })

-- Set the keymap to search vim commands using Telescope
vim.api.nvim_set_keymap('n', '<leader>p', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })

-- Set the keymap to toggle Neotree pane
vim.api.nvim_set_keymap('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })


