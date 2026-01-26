function wth --description 'weather forecast from wttr.in'
    if test (count $argv) -eq 0
        curl https://wttr.in/
    else
        curl https://wttr.in/$argv[1]
    end
end
