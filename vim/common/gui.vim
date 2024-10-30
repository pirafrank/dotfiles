"
" apply these settings only with GUIs.
" Made for gVim and neovim-qt, on both Linux and Windows.
" They work over X11 via SSH and on WSL via WSLg.
"

if has("gui_running")

  "set highlightning colors
  "colorscheme flatland

  "set window width
  set columns=140

  "set window height
  set lines=48

  "enable use of mouse
  set mouse=a

  " set font for when running with GUI
  " nb. in GUI, you can use :set guifont=* to list available fonts

  "set guifont=Consolas:h11
  "set guifont=MesloLGS\ Nerd\ Font\ Mono:h10

  " nvim means neovim-qt, vim means gVim.
  if has('win32') || has('win64')
    if has('nvim')
      set guifont=JetBrainsMono\ NFM:h10
    else
      set guifont=JetBrainsMono_NFM:h10
    endif
  else
    if has('nvim')
      set guifont=JetBrainsMono\ NFM:h10
    else
      set guifont=JetBrainsMono\ Nerd\ Font\ Mono\ 10
    endif
  endif

endif
