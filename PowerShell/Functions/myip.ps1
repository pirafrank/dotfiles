function myip { curl.exe ipinfo.io/json | ConvertFrom-Json }
