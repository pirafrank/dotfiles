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

-- Preview of the search in Telescope
vim.opt.inccommand = 'nosplit'
