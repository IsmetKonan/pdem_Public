# Functions

function Set-ConsoleColor ($bc, $fc) {
    $Host.UI.RawUI.BackgroundColor = $bc
    $Host.UI.RawUI.ForegroundColor = $fc
    Clear-Host
}

# Variables
$version = "1.1"
$emptyline = "                                                                 "
$deko = "-----------------------------------------------------------------"

# Setup 

Set-ConsoleColor 'black' 'blue'
Write-Host $emptyline
Write-Host $deko
Write-Host "    ____                    __     __ __                      "
Write-Host "   /  _/________ ___  ___  / /_   / //_/___  ____  ____ _____ "
Write-Host "   / // ___/ __ `__ \/ _ \/ __/  / ,< / __ \/ __ \/ __ `/ __ \"
Write-Host " _/ /(__  ) / / / / /  __/ /_   / /| / /_/ / / / / /_/ / / / /"
Write-Host "/___/____/_/ /_/ /_/\___/\__/  /_/ |_\____/_/ /_/\__,_/_/ /_/ "                                                             
Write-Host $deko
Write-Host $emptyline
Write-Host "CC Ismet Konan"
Write-Host "$version starting Installer setup ..."
Write-Host "Removing old setup file ..."
Write-Host $deko

$oldmain = Join-Path $PSScriptRoot "temp.ps1"
if (Test-Path $oldmain) {
    Remove-Item $oldmain -Force
    Write-Host "Old main.ps1 removed." -ForegroundColor Yellow
}

$mainUrl = "https://raw.githubusercontent.com/IsmetKonan/pdem_Public/main/main.ps1"
$mainPath = Join-Path $PSScriptRoot "main.ps1"

Invoke-WebRequest -Uri $mainUrl -OutFile $mainPath -ErrorAction Stop
Write-Host "main.ps1 downloaded." -ForegroundColor Green

Write-Host "Running main.ps1 ..." -ForegroundColor Cyan
& $mainPath
