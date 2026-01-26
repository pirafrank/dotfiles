function fff --description 'fff file manager with cd on exit'
    # set CD-on-exit for fff
    # https://github.com/dylanaraps/fff#cd-on-exit
    command fff $argv
    set -l fff_cache (test -n "$XDG_CACHE_HOME"; and echo "$XDG_CACHE_HOME"; or echo "$HOME/.cache")
    cd (cat "$fff_cache/fff/.fff_d")
end
