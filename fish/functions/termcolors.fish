function termcolors --description 'display all 256 terminal colors'
    for i in (seq 0 255)
        printf "\x1b[38;5;%smcolor%-5s\x1b[0m" $i $i
        if test (math "($i + 1) % 8") -eq 0
            echo
        end
    end
end
