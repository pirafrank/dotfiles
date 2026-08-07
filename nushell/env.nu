# Nushell environment configuration
#
# This file is loaded for every Nushell session.  It intentionally only adds
# paths when they exist, so the same configuration works on Linux, WSL2, and
# native Windows.

$env.EDITOR = ($env.EDITOR? | default "vim")
$env.VISUAL = ($env.VISUAL? | default $env.EDITOR)
$env.PAGER = ($env.PAGER? | default "less")

if ($env.LANG? | is-empty) {
    $env.LANG = "en_US.UTF-8"
    $env.LC_ALL = $env.LANG
}

$env.DOTFILES = ($env.DOTFILES? | default ($nu.home-dir | path join "dotfiles"))
$env.XDG_CONFIG_HOME = ($env.XDG_CONFIG_HOME? | default ($nu.home-dir | path join ".config"))
$env.XDG_DATA_HOME = ($env.XDG_DATA_HOME? | default ($nu.home-dir | path join ".local" "share"))
$env.XDG_CACHE_HOME = ($env.XDG_CACHE_HOME? | default ($nu.home-dir | path join ".cache"))
$env.LESS = ($env.LESS? | default "-g -i -M -R -S -w -z-4")
$env.RIPGREP_CONFIG_PATH = ($env.RIPGREP_CONFIG_PATH? | default ($env.DOTFILES | path join "rg" ".ripgreprc"))
$env.ZELLIJ_CONFIG_DIR = ($env.ZELLIJ_CONFIG_DIR? | default ($env.DOTFILES | path join "zellij"))
$env.BAT_STYLE = ($env.BAT_STYLE? | default "changes,header,numbers,snip")

# Nushell represents PATH as a list.  This helper also works when PATH came
# from a Windows installer or Scoop shim directory.
def --env add-path [value: string, --append] {
    if ($value | path exists) {
        if $append {
            $env.PATH = ($env.PATH | append $value | uniq)
        } else {
            $env.PATH = ($env.PATH | prepend $value | uniq)
        }
    }
}

# User paths have precedence over system paths, matching the zsh setup.
for path in [
    ($nu.home-dir | path join "bin2")
    ($nu.home-dir | path join ".local" "bin")
    ($env.DOTFILES | path join "bin")
    ($nu.home-dir | path join ".local" "share" "poof" "bin")
] {
    add-path $path
}

# Common language and CLI tool locations.
add-path ($nu.home-dir | path join ".cargo" "bin")
add-path ($nu.home-dir | path join ".krew" "bin")
add-path ($nu.home-dir | path join ".wasmtime" "bin")
add-path ($nu.home-dir | path join ".deno" "bin")
add-path ($nu.home-dir | path join ".serverless" "bin")
add-path ($nu.home-dir | path join ".local" "share" "pnpm")
add-path ($nu.home-dir | path join ".bun" "bin")
add-path ($nu.home-dir | path join ".tfenv" "bin")
add-path ($nu.home-dir | path join ".opencode" "bin")
add-path ($nu.home-dir | path join "bin2" "maven" "bin")

if ($nu.os-info.name == "linux") {
    add-path "/opt/local/bin"
    add-path "/opt/local/sbin"
    add-path "/usr/local/bin"
    add-path "/usr/local/sbin"
    add-path "/opt/swift/usr/bin"
}

if ($env.KREW_ROOT? | is-not-empty) {
    add-path ($env.KREW_ROOT | path join "bin")
}

if ($env.GOPATH? | is-empty) {
    $env.GOPATH = ($nu.home-dir | path join ".golang")
}
add-path ($env.GOPATH | path join "bin")

if ($nu.home-dir | path join ".pyenv" | path exists) {
    $env.PYENV_ROOT = ($nu.home-dir | path join ".pyenv")
    add-path ($env.PYENV_ROOT | path join "bin")
    add-path ($env.PYENV_ROOT | path join "shims")
}

if ($nu.home-dir | path join ".jenv" | path exists) {
    add-path ($nu.home-dir | path join ".jenv" "bin")
    add-path ($nu.home-dir | path join ".jenv" "shims")
}

if ($nu.home-dir | path join ".goenv" | path exists) {
    $env.GOENV_ROOT = ($nu.home-dir | path join ".goenv")
    add-path ($env.GOENV_ROOT | path join "bin")
    add-path ($env.GOENV_ROOT | path join "shims")
}

if ($nu.home-dir | path join ".nvm" | path exists) {
    $env.NVM_DIR = ($nu.home-dir | path join ".nvm")
}

if ($nu.home-dir | path join ".wasmer" | path exists) {
    $env.WASMER_DIR = ($nu.home-dir | path join ".wasmer")
    add-path ($env.WASMER_DIR | path join "bin")
}

if ($nu.home-dir | path join ".rvm" | path exists) {
    add-path ($nu.home-dir | path join ".rvm" "bin")
}

