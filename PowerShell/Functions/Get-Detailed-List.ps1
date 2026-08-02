function Get-Detailed-List([string]$path) {
    Get-ChildItem $path -Recurse -Force | Where-Object { $_.LinkType } | Select-Object FullName, LinkType, Target
}
