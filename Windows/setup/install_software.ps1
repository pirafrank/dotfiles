
###################################
############ functions ############
###################################

Function Update-Env {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}


###################################
############ preparing ############
###################################

# update winget repos
winget source update

# refreshing path
# consider winget suffers from this issue:
#   https://github.com/microsoft/winget-cli/issues/222
if ($PSVersionTable.PSVersion.Major -ge 7) {
  refreshenv
}
else {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
}

# install powershell 7
winget install --id Microsoft.Powershell --source winget

###################################
####### installing software #######
###################################

## essential dev tools

winget install -e --id Git.Git
winget install -e --id Microsoft.WindowsTerminal.Preview

winget install -e --id Microsoft.VisualStudioCode
winget install -e --id Notepad++.Notepad++

## dev tools

winget install -e --id Microsoft.AzureCLI
winget install -e --id Amazon.AWSCLI
winget install -e --id Amazon.SAM-CLI

winget install -e --id Fork.Fork
winget install -e --id JetBrains.Toolbox

winget install -e --id Microsoft.Azure.StorageExplorer
winget install -e --id PostgreSQL.pgAdmin
winget install -e --id PuTTY.PuTTY
winget install -e --id WinFsp.WinFsp
winget install -e --id WinMerge.WinMerge
winget install -e --id WinSCP.WinSCP
winget install -e --id SmartBear.SoapUI
winget install -e --id Telerik.Fiddler.Classic
winget install -e --id qishivo.AnotherRedisDesktopManager

## environments

winget install -e --id Microsoft.DotNet.SDK.7
winget install -e --id Python.Python.3.11
winget install -e --id Python.Python.3.9
winget install -e --id GoLang.Go
winget install -e --id Python.Launcher
winget install -e --id Docker.DockerDesktop  # docker desktop also installas kubectl

## essential desktop utilities

winget install -e --id 7zip.7zip
winget install -e --id namazso.OpenHashTab
winget install -e --id Skillbrains.Lightshot
winget install -e --id SomePythonThings.WingetUIStore
winget install -e --id Microsoft.PowerToys
winget install -e --id WinDirStat.WinDirStat
winget install -e --id Armin2208.WindowsAutoNightMode
choco install -y sysinternals

## desktop essentials

winget install -e --id Mozilla.Firefox
winget install -e --id Google.Chrome
winget install -e --id Microsoft.Edge
winget install -e --id Microsoft.EdgeWebView2Runtime

winget install -e --id Bitwarden.Bitwarden
winget install -e --id Cryptomator.Cryptomator
winget install -e --id KeePassXCTeam.KeePassXC

winget install -e --id GnuPG.GnuPG
winget install -e --id GnuPG.Gpg4win
winget install -e --id Yubico.YubikeyManager

winget install -e --id OpenVPNTechnologies.OpenVPN
winget install -e --id ZeroTier.ZeroTierOne
winget install -e --id tailscale.tailscale
winget install -e --id NordSecurity.NordVPN
winget install -e --id Ngrok.Ngrok

winget install -e --id Microsoft.OneDrive
winget install -e --id Iterate.Cyberduck
winget install -e --id Iterate.MountainDuck
winget install -e --id Notion.Notion

## generic desktop utils

winget install -e --id Adobe.Acrobat.Reader.64-bit
winget install -e --id VideoLAN.VLC
winget install -e --id dotPDNLLC.paintdotnet
winget install -e --id Loom.Loom

# desktop webcall software

winget install -e --id Microsoft.Teams
winget install -e --id Cisco.WebexTeams
winget install -e --id Zoom.Zoom


###################################
######### Installing WSL2 #########
###################################

Write-Output "Installing Windows Subsystem for Linux..."
wsl --install

# installing ubuntu distro
winget install -e --id Canonical.Ubuntu

# Need it no more! Windows 11 WSL2 supports X11 apps natively.
#winget install -e --id marha.VcXsrv


###################################
#### installing extra software ####
###################################

Write-Output "Installing extra software..."

#winget install -e --id CiderCollective.Cider
#winget install -e --id Nushell.Nushell
#winget install -e --id OpenWhisperSystems.Signal

#winget install -e --id XP8K17RNMM8MTN --source msstore # Canva


# finally, check installed packages

Write-Output "Re-listing installed packages..."
winget list | Sort-Object
