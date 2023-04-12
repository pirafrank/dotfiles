"apply these settings only with GUIs, like MacVim
if has("gui_running")

  "set highlightning colors
  colorscheme flatland

  "set window width
  set columns=140

  "set window height
  set lines=48

  "enable use of mouse
  set mouse=a

  "set font for gVim on Windows
  if has("gui_win32")
    "set guifont=MesloLGS\ Nerd\ Font\ Mono:h10
    set guifont=JetBrains\ Mono:h10
  endif

  " settings for GUI nvim
  if has('nvim')

    " 4-bit colorschemes and settings
    "set background=light
    set background=dark
    "colorscheme hemisu

  endif

endif
