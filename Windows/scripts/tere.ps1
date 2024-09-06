# import tere
function Invoke-Tere() {
  $result = . (Get-Command -CommandType Application tere) $args
  if ($result) {
    Set-Location $result
  }
}
Set-Alias tere Invoke-Tere
