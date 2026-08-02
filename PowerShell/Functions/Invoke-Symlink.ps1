function Invoke-Symlink($shortcutTarget, $shortcutName) {
    New-Item -Type SymbolicLink -Path "$shortcutName" -Target "$shortcutTarget"
}
