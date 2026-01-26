function tat --description 'tmux attach helper - attach to session or create if it does not exist'
    if test (count $argv) -eq 0
        tmux ls
    else
        tmux attach -t $argv[1]; or tmux new -s $argv[1]
    end
end
