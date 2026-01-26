function lf --description 'lf file manager with cd on exit'
    cd (command lf -print-last-dir $argv)
end
