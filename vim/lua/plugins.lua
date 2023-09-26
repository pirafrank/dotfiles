-- shared options
local ns = { noremap = true, silent = true }

-- Stabilize.nvim
require('stabilize').setup()

-- Gitsigns
require('gitsigns').setup()

-- Telescope
local telescope = require('telescope')
local actions = require("telescope.actions")
telescope.setup{
    defaults = {
        preview = true,
        mappings = {
            i = {
                ["<C-c>"] = actions.close,
                ["?"] = actions.which_key,
            },
            n = {
                ["<esc>"] = actions.close,
                ["?"] = actions.which_key,
            },
        },
    },
}

-- Preview of the search
vim.opt.inccommand = 'nosplit'

local builtin = require('telescope.builtin')
-- file pickers
vim.keymap.set('n', '<C-t>', builtin.find_files, {})
vim.keymap.set('n', '<leader>gg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim pickers
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<C-o>', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>hk', builtin.keymaps, {})
vim.keymap.set('n', '<leader>hh', builtin.help_tags, {})
-- git pickers
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_bcommits, {})


