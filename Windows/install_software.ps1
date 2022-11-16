
###################################
############ functions ############
###################################

# credits: https://www.powershellgallery.com/packages/WingetTools/0.5.0/Content/functions%5CInstall-Winget.ps1
Function Install-WinGet {
    #Install the latest package from GitHub
    [cmdletbinding(SupportsShouldProcess)]
    [alias("iwg")]
    [OutputType("None")]
    [OutputType("Microsoft.Windows.Appx.PackageManager.Commands.AppxPackage")]
    Param(
        [Parameter(HelpMessage = "Display the AppxPackage after installation.")]
        [switch]$Passthru
    )

    Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($myinvocation.mycommand)"

    if ($PSVersionTable.PSVersion.Major -eq 7) {
        Write-Warning "This command does not work in PowerShell 7. You must install in Windows PowerShell."
        return
    }

    #test for requirement
    $Requirement = Get-AppPackage "Microsoft.DesktopAppInstaller"
    if (-Not $requirement) {
        Write-Verbose "Installing Desktop App Installer requirement"
        Try {
            Add-AppxPackage -Path "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -erroraction Stop
        }
        Catch {
            Throw $_
        }
    }

    $uri = "https://api.github.com/repos/microsoft/winget-cli/releases"

    Try {
        Write-Verbose "[$((Get-Date).TimeofDay)] Getting information from $uri"
        $get = Invoke-RestMethod -uri $uri -Method Get -ErrorAction stop

        Write-Verbose "[$((Get-Date).TimeofDay)] getting latest release"
        #$data = $get | Select-Object -first 1
        $data = $get[0].assets | Where-Object name -Match 'msixbundle'

        $appx = $data.browser_download_url
        #$data.assets[0].browser_download_url
        Write-Verbose "[$((Get-Date).TimeofDay)] $appx"
        If ($pscmdlet.ShouldProcess($appx, "Downloading asset")) {
            $file = Join-Path -path $env:temp -ChildPath $data.name

            Write-Verbose "[$((Get-Date).TimeofDay)] Saving to $file"
            Invoke-WebRequest -Uri $appx -UseBasicParsing -DisableKeepAlive -OutFile $file

            Write-Verbose "[$((Get-Date).TimeofDay)] Adding Appx Package"
            Add-AppxPackage -Path $file -ErrorAction Stop

            if ($passthru) {
                Get-AppxPackage microsoft.desktopAppInstaller
            }
        }
    } #Try
    Catch {
        Write-Verbose "[$((Get-Date).TimeofDay)] There was an error."
        Throw $_
    }
    Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($myinvocation.mycommand)"
}


###################################
############ preparing ############
###################################

## install chocolatey

Write-Output "Installing chocolatey..." 

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# attaching chocolatey at the end of PATH
$env:Path += ";%ALLUSERSPROFILE%\chocolatey\bin"

## install winget

Write-Output "Installing winget..." 
Install-WinGet

# listing installed packages

Write-Output "Listing installed packages..." 
winget list | Sort-Object


###################################
####### installing software #######
###################################

## dev tools

Write-Output "Installing dev tools..." 

choco install -y wget curl sysinternals
choco install -y duck cyberduck
choco install -y fzf
choco install -y mockoon
choco install -y rsync
choco install -y krew

choco install -y oraclejdk maven nodejs python3 deno go
choco install -y vscode dbeaver
choco install -y microsoftazurestorageexplorer servicebusexplorer

winget install -e --id CoreyButler.NVMforWindows
winget install -e --id Microsoft.AzureCLI
winget install -e --id Amazon.AWSCLI
winget install -e --id Amazon.SAM-CLI
winget install -e --id Git.Git
winget install -e --id GitHub.cli

winget install -e --id Docker.DockerDesktop
winget install -e --id Fork.Fork
winget install -e --id JetBrains.Toolbox
winget install -e --id Meld.Meld
winget install -e --id Notepad++.Notepad++
winget install -e --id Alacritty.Alacritty
winget install -e --id Microsoft.WindowsTerminal.Preview

winget install -e --id Mozilla.Firefox
winget install -e --id Google.Chrome

winget install -e --id Insomnia.Insomnia
winget install -e --id Postman.Postman

winget install -e --id PostgreSQL.pgAdmin
winget install -e --id PuTTY.PuTTY
winget install -e --id WinFsp.WinFsp
winget install -e --id WinMerge.WinMerge
winget install -e --id WinSCP.WinSCP
winget install -e --id SmartBear.SoapUI
winget install -e --id Telerik.Fiddler.Classic
winget install -e --id Wasmer.Wasmer

## essentials

Write-Output "Installing essentials software..." 

choco install -y adobereader caffeine

winget install -e --id 7zip.7zip
winget install -e --id GnuPG.GnuPG
winget install -e --id GnuPG.Gpg4win
winget install -e --id Skillbrains.Lightshot
winget install -e --id namazso.OpenHashTab

winget install -e --id Bitwarden.Bitwarden
winget install -e --id Cryptomator.Cryptomator
winget install -e --id KeePassXCTeam.KeePassXC

winget install -e --id OpenVPNTechnologies.OpenVPN
winget install -e --id ZeroTier.ZeroTierOne

winget install -e --id Microsoft.OneDrive
winget install -e --id Microsoft.Teams
winget install -e --id Cisco.WebexTeams

## utils

Write-Output "Installing utilities..." 

choco install -y paint.net
choco install -y vlc

winget install -e --id Microsoft.PowerToys
winget install -e --id Armin2208.WindowsAutoNightMode
winget install -e --id Loom.Loom
winget install -e --id RealVNC.VNCViewer
winget install -e --id WinDirStat.WinDirStat

# check installed packages

Write-Output "Re-listing installed packages..." 
winget list | Sort-Object


###################################
######### cloning dotfiles ########
###################################

Set-Location "$env:UserProfile"
git clone https://github.com/pirafrank/dotfiles

# create 'Code' dir

New-Item "$env:UserProfile\Code" -itemType Directory


###################################
######### Installing WSL2 #########
###################################

Write-Output "Installing Windows Subsystem for Linux..."
wsl --install

# installing ubuntu distro and X server
winget install -e --id Canonical.Ubuntu
winget install -e --id marha.VcXsrv


###################################
#### installing extra software ####
###################################

Write-Output "Installing extra software..."

winget install -e --id CiderCollective.Cider
winget install -e --id Nushell.Nushell
winget install -e --id OpenWhisperSystems.Signal
winget install -e --id Typora.Typora

winget install -e --id XP8K17RNMM8MTN --source msstore # Canva
