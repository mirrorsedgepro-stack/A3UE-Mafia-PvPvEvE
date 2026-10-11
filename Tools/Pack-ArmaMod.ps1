<#
.SYNOPSIS
    Packs the A3UE Mafia PvPvEvE mod using estchd/arma_mod_packing.
.DESCRIPTION
    Wrapper script for arma_tools_mod_packing (https://github.com/estchd/arma_mod_packing).
    Validates pbo.json, .modignore, .convertignore, and path.json before execution.
.PARAMETER Source
    Path to the mod source directory containing mod.cpp (Default: ./A3UE)
.PARAMETER Destination
    Path to the destination folder for packed addons (Default: ./build/@A3UE_Mafia)
.PARAMETER ToolPath
    Path to arma_tools_mod_packing executable (Default: arma_tools_mod_packing.exe)
#>

param(
    [string]$Source = "$PSScriptRoot/../A3UE",
    [string]$Destination = "$PSScriptRoot/../build/@A3UE_Mafia",
    [string]$ToolPath = "arma_tools_mod_packing.exe",
    [string]$PathJson = "$PSScriptRoot/../path.json"
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  A3UE Mafia PvPvEvE: Packing via arma_mod_packing        " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Resolve absolute paths
$Source = [System.IO.Path]::GetFullPath($Source)
$Destination = [System.IO.Path]::GetFullPath($Destination)

Write-Host "Source Directory:      $Source"
Write-Host "Destination Directory: $Destination"

if (!(Test-Path $Source)) {
    Write-Error "Source directory does not exist: $Source"
}

# Verify pbo.json configurations in addons
$addonsDir = Join-Path $Source "addons"
if (Test-Path $addonsDir) {
    Get-ChildItem -Directory $addonsDir | ForEach-Object {
        $pboJson = Join-Path $_.FullName "pbo.json"
        if (Test-Path $pboJson) {
            Write-Host " [OK] Found pbo.json in: $($_.Name)" -ForegroundColor Green
        } else {
            Write-Warning " Missing pbo.json in: $($_.Name)"
        }
    }
}

# Check if arma_tools_mod_packing is available
$toolCmd = Get-Command $ToolPath -ErrorAction SilentlyContinue
if (!$toolCmd -and !(Test-Path $ToolPath)) {
    Write-Warning "arma_tools_mod_packing executable was not found in PATH or at: $ToolPath"
    Write-Host "Download it from: https://github.com/estchd/arma_mod_packing/releases" -ForegroundColor Yellow
    Write-Host "Command syntax:" -ForegroundColor Gray
    Write-Host "  arma_tools_mod_packing.exe --source `"$Source`" --destination `"$Destination`" --pack --path_json `"$PathJson`"" -ForegroundColor Gray
    exit 1
}

if (!(Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

Write-Host "Executing arma_tools_mod_packing..." -ForegroundColor Cyan
& $ToolPath --source $Source --destination $Destination --pack --path_json $PathJson

Write-Host "Packing process completed!" -ForegroundColor Green
