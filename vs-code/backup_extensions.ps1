function print($str) {
    Write-Host "$str"
}

if ( $($args.Count) -ne 1 ) {
    $scriptName = $MyInvocation.MyCommand.Name
    print('Please add output filename as argument')
    print("Usage: .\$scriptName output_filename")
    exit
}

$file=$args[0] 
code --list-extensions | Sort-Object | ForEach-Object { 
"code --install-extension $_"
} | Out-File -FilePath ".\$file.ps1" -Encoding utf8
