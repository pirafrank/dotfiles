function dotup --description 'update dotfiles repository'
    # update dotfiles
    cd ~/dotfiles; or return 1
    if test (git rev-parse --abbrev-ref HEAD) = 'main'
        git pull --rebase --autostash origin main
    else
        echo "Error: can't update dotfiles repo, not on 'main' branch."
    end
    cd -
end
