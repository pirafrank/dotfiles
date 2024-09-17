param (
    [string]$filepath
)

$bytes = [System.IO.File]::ReadAllBytes($filepath)
$peHeaderOffset = [BitConverter]::ToUInt32($bytes, 0x3C)
$machineType = [BitConverter]::ToUInt16($bytes, $peHeaderOffset + 4)

if ($machineType -eq 0x8664) {
    "64-bit"
}
elseif ($machineType -eq 0x14c) {
    "32-bit"
}
else {
    "Unknown architecture"
}
