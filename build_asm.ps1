# EditPad Pro - Native x64 Assembly Build Script (PowerShell)
$ErrorActionPreference = "Stop"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host " EditPad Pro - Native x64 Assembly Build Tool (PowerShell)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

$ml64 = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64\ml64.exe"
$link = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64\link.exe"
$sdkLib = "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64"

if (-not (Test-Path $ml64)) {
    $found = Get-ChildItem "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\*\bin\Hostx64\x64\ml64.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $ml64 = $found.FullName
        $link = Join-Path (Split-Path $ml64) "link.exe"
    }
}

if (-not (Test-Path $sdkLib)) {
    $foundLib = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\Lib\10.*\um\x64\kernel32.lib" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($foundLib) {
        $sdkLib = Split-Path $foundLib.FullName
    }
}

Write-Host "[1/3] Assembling edit.asm (x64 MASM)..." -ForegroundColor Yellow
& $ml64 /c /nologo /Foedit.obj (Join-Path $PSScriptRoot "edit.asm")
if ($LASTEXITCODE -ne 0) {
    Write-Error "Assembly failed with exit code $LASTEXITCODE"
}

Write-Host "[2/3] Linking edit.obj into edit.exe..." -ForegroundColor Yellow
$outPath = Join-Path $PSScriptRoot "edit.exe"
& $link /nologo /subsystem:windows /entry:main (Join-Path $PSScriptRoot "edit.obj") `
    (Join-Path $sdkLib "kernel32.lib") `
    (Join-Path $sdkLib "user32.lib") `
    (Join-Path $sdkLib "gdi32.lib") `
    (Join-Path $sdkLib "comdlg32.lib") `
    (Join-Path $sdkLib "comctl32.lib") `
    "/out:$outPath"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Linking failed with exit code $LASTEXITCODE"
}

Write-Host "[3/3] Cleaning up temporary build artifacts..." -ForegroundColor Yellow
Remove-Item (Join-Path $PSScriptRoot "edit.obj") -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host " BUILD SUCCESSFUL: edit.exe generated successfully!" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Get-Item (Join-Path $PSScriptRoot "edit.exe") | Format-Table Name, Length, LastWriteTime
