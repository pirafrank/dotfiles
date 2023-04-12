
" command to generate ctags for current project, hidden inside .git dir
command! Mktags !ctags -R -f ./.git/ctags .

" in vim, set the paths where to look for ctags
set tags=./.git/ctags;$HOME

" if you don't put ctags file in project root (e.g. you hide it into the .git folder)
" from the docs: 'tagrelative' Controls how the file names in the tags file are treated. 
" When on, the filenames are relative to the directory where the tags file is present.
set notagrelative

