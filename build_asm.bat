@echo off
setlocal enabledelayedexpansion
title Building EditPad Pro (x64 Assembly)

echo ========================================================
echo  EditPad Pro — Native x64 Assembly Build Tool
echo ========================================================
echo.

:: Detect Visual Studio / MSVC Tools
set "ML64_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64\ml64.exe"
set "LINK_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64\link.exe"
set "SDK_LIB=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64"

if not exist "%ML64_PATH%" (
    :: Fallback search via vswhere or standard VS installations
    for /d %%i in ("C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\*") do (
        if exist "%%i\bin\Hostx64\x64\ml64.exe" (
            set "ML64_PATH=%%i\bin\Hostx64\x64\ml64.exe"
            set "LINK_PATH=%%i\bin\Hostx64\x64\link.exe"
        )
    )
)

if not exist "%SDK_LIB%" (
    for /d %%k in ("C:\Program Files (x86)\Windows Kits\10\Lib\10.*") do (
        if exist "%%k\um\x64\kernel32.lib" (
            set "SDK_LIB=%%k\um\x64"
        )
    )
)

echo [1/3] Assembling edit.asm (x64 MASM)...
"%ML64_PATH%" /c /nologo /Foedit.obj edit.asm
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Assembly failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

echo [2/3] Linking edit.obj into edit.exe...
"%LINK_PATH%" /nologo /subsystem:windows /entry:main edit.obj ^
    "%SDK_LIB%\kernel32.lib" ^
    "%SDK_LIB%\user32.lib" ^
    "%SDK_LIB%\gdi32.lib" ^
    "%SDK_LIB%\comdlg32.lib" ^
    "%SDK_LIB%\comctl32.lib" ^
    /out:edit.exe

if %ERRORLEVEL% neq 0 (
    echo [ERROR] Linking failed with error code %ERRORLEVEL%.
    exit /b %ERRORLEVEL%
)

echo [3/3] Cleaning up build artifacts...
if exist edit.obj del edit.obj

echo.
echo ========================================================
echo  BUILD SUCCESSFUL: edit.exe generated successfully!
echo ========================================================
dir edit.exe
exit /b 0
