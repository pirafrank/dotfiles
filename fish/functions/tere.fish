function tere --description 'tere file navigator with cd on exit'
    set -l result (command tere $argv)
    test -n "$result"; and cd -- "$result"
end
