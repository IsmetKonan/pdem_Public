param(
    [switch]$SkipUpdate
)

# ==============================
# Safety: installer must never update itself
# ==============================
$ForceUpdate = $false

# ==============================
# Variables
# ==============================
$version = "1.1"
$Root = $PSScriptRoot

$TempScript = Join-Path $Root "temp.ps1"
$MainScript = Join-Path $Root "main.ps1"
$LogFile    = Join-Path $Root "log.txt"

$MainUrl = "https://raw.githubusercontent.com/IsmetKonan/pdem_Public/main/main.ps1"

# ==============================
# UI
# ==============================
Clear-Host
Write-Host "-----------------------------------------------------------------" -ForegroundColor Blue
Write-Host "    ____                    __     __ __"
Write-Host "   /  _/________ ___  ___  / /_   / //_/___  ____  ____ _____"
Write-Host "   / // ___/ __ __ \/ _ \/ __/  / ,< / __ \/ __ \/ __ / __ \"
Write-Host " _/ /(__  ) / / / / /  __/ /_   / /| / /_/ / / / / /_/ / / / /"
Write-Host "/___/____/_/ /_/ /_/\___/\__/  /_/ |_\____/_/ /_/\__,_/_/ /_/"
Write-Host "-----------------------------------------------------------------" -ForegroundColor Blue
Write-Host "CC Ismet Konan"
Write-Host "$version starting Installer setup ..."
Write-Host "-----------------------------------------------------------------"

# ==============================
# Cleanup old files
# ==============================
Write-Host "Cleaning up old files..." -ForegroundColor Yellow

if (Test-Path $TempScript) {
    Remove-Item $TempScript -Force
    Write-Host "Removed temp.ps1" -ForegroundColor Green
}

if (Test-Path $LogFile) {
    Remove-Item $LogFile -Force
    Write-Host "Removed log file" -ForegroundColor Green
}

# ==============================
# Download new main.ps1
# ==============================
Write-Host "Downloading main.ps1..." -ForegroundColor Yellow

try {
    Invoke-WebRequest -Uri $MainUrl -OutFile "$MainScript.new" -ErrorAction Stop
    Write-Host "Download successful." -ForegroundColor Green
} catch {
    Write-Host "FAILED to download main.ps1" -ForegroundColor Red
    exit 1
}

# ==============================
# Replace installer with main
# ==============================
Write-Host "Applying update..." -ForegroundColor Cyan

$SelfReplace = @"
Start-Sleep -Seconds 1

# Delete old main if exists
if (Test-Path '$MainScript') {
    Remove-Item '$MainScript' -Force
}

# Rename downloaded main
Rename-Item '$MainScript.new' 'main.ps1'

# Delete installer
Remove-Item '$PSCommandPath' -Force
"@

$ReplaceScript = Join-Path $Root "replace.ps1"
$SelfReplace | Out-File $ReplaceScript -Encoding UTF8

Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ReplaceScript`"" -WindowStyle Hidden

Write-Host "Update completed. Exiting installer." -ForegroundColor Green
exit
