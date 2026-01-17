--- colorscheme settings

-- you can use default theme and customize terminal colors instead.
-- just be sure to disabled termguicolors.
-- vim.cmd('colorscheme default')

-- enable 24-bit color support instead of 256 color palette.
-- do not enable this if you want to use 16-color terminal schemes.
vim.opt.termguicolors = true

-- set colorscheme
-- vim.cmd('colorscheme molokai')
-- vim.cmd('colorscheme dracula')
-- vim.cmd('colorscheme onedark')

-- my 2nd fav color scheme
vim.g.tokyonight_style = 'storm' -- available: night, storm
vim.g.tokyonight_enable_italic = 1
vim.g.airline_theme = 'onedark' -- tokyonight does not have airline theme yet
vim.cmd('colorscheme tokyonight')

-- settings to use vim-plastic colorscheme
-- (live in plastic, it's fantastic)
-- vim.opt.background = 'dark'
-- vim.cmd('colorscheme plastic')
-- vim.g.lightline = { colorscheme = 'plastic' }

-- sonokai vim colorscheme
-- The configuration options should be placed before `colorscheme sonokai`.
-- vim.g.sonokai_style = 'andromeda'
-- vim.g.sonokai_enable_italic = 0
-- vim.g.sonokai_disable_italic_comment = 1
-- vim.cmd('colorscheme sonokai')

-- vim-material colorscheme
-- vim.g.material_style = 'oceanic'
-- vim.opt.background = 'dark'
-- vim.cmd('colorscheme vim-material')

-- 4-bit colorschemes to get consistency in 16-color terminals
-- set one of these and customize your terminal theme instead.
-- vim.cmd('colorscheme noctu')
-- vim.cmd('colorscheme dim')

-- keep line numbers grey
vim.cmd('highlight LineNr ctermfg=grey')
