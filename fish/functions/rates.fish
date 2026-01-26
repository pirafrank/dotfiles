function rates --description 'currency exchange rates from rate.sx'
    if test (count $argv) -eq 0
        curl http://rate.sx/
    else
        curl http://rate.sx/$argv[1]
    end
end
