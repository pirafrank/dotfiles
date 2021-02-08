function print($str) {
    Write-Host "$str"
}

if ( $($args.Count) -ne 2 -And $($args.Count) -ne 3 ) {
    $scriptName = $MyInvocation.MyCommand.Name
    print("Usage: .\$scriptName [args...] pubKeyFile user@host")
    exit
}

$sshargs=""
$sshPubKey=$args[0]
$remoteHost=$args[1]

if ( $($args.Count) -eq 3 ) {
  $sshargs=$args[0]
  $sshPubKey=$args[1]
  $remoteHost=$args[2]
}

type $env:USERPROFILE\.ssh\$sshPubKey | ssh "$sshargs" "$remoteHost" "cat >> .ssh/authorized_keys"
