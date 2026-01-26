function mkcd --description 'mkdir && cd, or fix the last cd if it failed because the directory did not exist'
    if test (count $argv) -eq 0
        # No arguments, try to fix last cd command
        set -l last_cmd (history --max=1 | string trim)
        if string match -q 'cd *' $last_cmd
            set -l dir (string replace -r '^cd\s+' '' $last_cmd)
            mkdir -p $dir; and cd $dir
        else
            echo "Exactly one argument expected, or run after a 'cd some_dir' that exited on error for some_dir non existing."
            return 1
        end
    else
        mkdir -p $argv[1]; and cd $argv[1]
    end
end
