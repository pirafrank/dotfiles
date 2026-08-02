$script:java8  = "C:\Java\jdk8"
$script:java11 = "C:\Java\jdk11"
$script:java16 = "C:\Java\jdk16"
$script:java17 = "C:\Java\jdk17"

function Set-Java-Path($jpath) {
    $binPath = "$jpath\bin"
    $env:Path = "$binPath$([IO.Path]::PathSeparator)$env:Path"
    $persisted = [Environment]::GetEnvironmentVariable("Path")
    [Environment]::SetEnvironmentVariable("Path", "$binPath$([IO.Path]::PathSeparator)$persisted")
    java -version
}

function java8 {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $script:java8)
    Set-Java-Path $script:java8
}

function java11 {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $script:java11)
    Set-Java-Path $script:java11
}

function java16 {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $script:java16)
    Set-Java-Path $script:java16
}

function java17 {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $script:java17)
    Set-Java-Path $script:java17
}

foreach ($name in 'java8', 'java11', 'java16', 'java17', 'Set-Java-Path') {
    Remove-Item "function:global:$name" -Force -ErrorAction SilentlyContinue
}
