
# installed java versions
$java8 = "C:\Java\jdk8"
$java11 = "C:\Java\jdk11"
$java16 = "C:\Java\jdk16"
$java17 = "C:\Java\jdk17"

function Set-Java-Path($jpath) {
    $jpath += "\bin"
    $Path= $jpath + [IO.Path]::PathSeparator + [Environment]::GetEnvironmentVariable("PATH")
    [Environment]::SetEnvironmentVariable("Path", $Path)
    java -version
}

function java8 {
  [Environment]::SetEnvironmentVariable("JAVA_HOME", $java8)
  Set-Java-Path($java8)
}

function java11 {
  [Environment]::SetEnvironmentVariable("JAVA_HOME", $java11)
  Set-Java-Path($java11)
}

function java16 {
  [Environment]::SetEnvironmentVariable("JAVA_HOME", $java16)
  Set-Java-Path($java16)
}

function java17 {
  [Environment]::SetEnvironmentVariable("JAVA_HOME", $java17)
  Set-Java-Path($java17)
}
