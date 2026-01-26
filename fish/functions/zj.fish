function zj --description 'zellij smart launcher - uses .zellij_layout.kdl if present, otherwise some-tabs layout'
    # I consider .zellij_layout.kdl to be the default name for a zellij layout file
    # If it exists, use it. Otherwise, use the some-tabs layout defined among the
    # default layouts in dotfiles/zellij/layouts.
    # The last case allows this function to act as a wrapper of zellij, passing all
    # arguments to it.

    if test -f .zellij_layout.kdl; and test (count $argv) -eq 0
        zellij --layout .zellij_layout.kdl
    else if not test -f .zellij_layout.kdl; and test (count $argv) -eq 0
        zellij --layout some-tabs
    else
        zellij $argv
    end
end
