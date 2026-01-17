""" colorscheme settings

" you can use default theme and customize terminal colors instead.
" just be sure to disabled termguicolors.
"color default

" enable 24-bit color support instead of 256 color palette.
" do not enable this if you want to use 16-color terminal schemes.
set termguicolors
" fallback for terminals which do not support true colors, use 256 colors instead of 16
set t_Co=256

" set colorscheme
"color molokai
"color dracula
silent! color onedark

" my 2nd fav color scheme
"let g:tokyonight_style = 'storm' " available: night, storm
"let g:tokyonight_enable_italic = 1
"let g:airline_theme = 'onedark'
"color tokyonight

" settings to use vim-plastic colorscheme
" (live in plastic, it's fantastic)
"set background=dark
"color plastic
"let g:lightline = { 'colorscheme': 'plastic' }

" sonokai vim colorscheme
" The configuration options should be placed before `colorscheme sonokai`.
"let g:sonokai_style = 'andromeda'
"let g:sonokai_enable_italic = 0
"let g:sonokai_disable_italic_comment = 1
"color sonokai

" vim-material colorscheme
"let g:material_style='oceanic'
"set background=dark
"colorscheme vim-material

" 4-bit colorschemes to get consistency in 16-color terminals
" set one of these and customize your terminal theme instead.
"color noctu
"color dim

" keep line numbers grey
highlight LineNr ctermfg=grey
