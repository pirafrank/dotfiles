function print($str) {
    Write-Host "$str"
}

if ( $($args.Count) -ne 2 ) {
    $scriptName = $MyInvocation.MyCommand.Name
    print("Usage: .\$scriptName target symlink_name")
    exit
}

$shortcutTarget=$args[0]
$shortcutName=$args[1]
New-Item -itemtype symboliclink -path . -name $shortcutName -value $shortcutTarget
