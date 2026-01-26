function cs --description 'cheat.sh - community driven cheat sheets'
    if test (count $argv) -eq 0
        curl -sSL cheat.sh | less
    else
        curl -sSL cheat.sh/$argv[1] | less
    end
end
