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
# Variables
# ==============================
$Root = $PSScriptRoot

$TempScript = Join-Path $Root "temp.ps1"
$LogFile    = Join-Path $Root "log.txt"

$InstallerUrl = "https://raw.githubusercontent.com/IsmetKonan/pdem_Public/main/realese/v1/installv1.ps1"
$NewMain     = Join-Path $Root "main.ps1"
$Downloaded  = Join-Path $Root "main.new.ps1"

# ==============================
# UI
# ==============================
Clear-Host
Write-Host "Installer v1 starting..." -ForegroundColor Cyan

# ==============================
# Cleanup
# ==============================
Write-Host "Cleaning old files..." -ForegroundColor Yellow

if (Test-Path $TempScript) { Remove-Item $TempScript -Force }
if (Test-Path $LogFile)    { Remove-Item $LogFile -Force }

# ==============================
# Download installv1.ps1 → main
# ==============================
Write-Host "Downloading new main.ps1..." -ForegroundColor Yellow

try {
    Invoke-WebRequest -Uri $InstallerUrl -OutFile $Downloaded -ErrorAction Stop
} catch {
    Write-Host "Download failed. Aborting update." -ForegroundColor Red
    exit 1
}

# ==============================
# Replace current script SAFELY
# ==============================
$ReplaceScript = @"
Start-Sleep -Seconds 1

if (Test-Path '$NewMain') {
    Remove-Item '$NewMain' -Force
}

Rename-Item '$Downloaded' 'main.ps1'

Remove-Item '$PSCommandPath' -Force
"@

$ReplacePath = Join-Path $Root "replace.ps1"
$ReplaceScript | Out-File $ReplacePath -Encoding UTF8

Start-Process powershell `
    -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ReplacePath`"" `
    -WindowStyle Hidden

Write-Host "Update applied successfully." -ForegroundColor Green
exit
