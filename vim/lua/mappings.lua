
-- shared options
local tsb = require('telescope.builtin')

local ns = { noremap = true, silent = true }
local bufopts = { noremap=true, silent=true, buffer=bufnr }

-- file pickers (via Telescope) --
vim.keymap.set('n', '<C-p>', tsb.find_files, ns)
vim.keymap.set('n', '<leader>gg', tsb.git_files, {})
vim.keymap.set('n', '<leader>fg', tsb.live_grep, {})

-- vim pickers (via Telescope) --
vim.keymap.set('n', '<C-b>', tsb.buffers, ns)
vim.keymap.set('n', '<leader>oo', tsb.oldfiles, ns)
-- search vim commands using Telescope
vim.keymap.set('n', '<leader>hh', tsb.help_tags, ns)
vim.keymap.set('n', '<leader>hk', tsb.keymaps, ns)

-- git pickers (via Telescope) --
vim.keymap.set('n', '<leader>gc', tsb.git_commits, {})
vim.keymap.set('n', '<leader>gb', tsb.git_bcommits, {})

-- Set the keymap to toggle Neotree pane
vim.api.nvim_set_keymap('n', '<C-n>', ':Neotree toggle<CR>', ns)
