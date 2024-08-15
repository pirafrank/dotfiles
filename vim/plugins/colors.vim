""" colorscheme settings

" set colorscheme
"color molokai
"color dracula
silent! color onedark

" my 2nd fav color scheme
"let g:tokyonight_style = 'storm' " available: night, storm
"let g:tokyonight_enable_italic = 1
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

" further theme customization
" you can use default theme and customize terminal colors instead
"color default

" keep line numbers grey
highlight LineNr ctermfg=grey
