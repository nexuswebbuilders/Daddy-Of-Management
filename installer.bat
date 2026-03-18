@echo off
title DADDY OF MANAGEMENT - INSTALLER
color 0A
mode con: cols=95 lines=30

:: ===========================================
:: ADMIN CHECK
:: ===========================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

cls
echo ===============================================================
echo                     DADDY OF MANAGEMENT
echo ===============================================================
echo.
echo Initializing Installation...
timeout /t 2 >nul

:: ===========================================
:: DOWNLOAD NODE MSI (OFFICIAL)
:: ===========================================

echo [1/4] Downloading Node.js 25.8.1...

powershell -Command ^
"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
 Invoke-WebRequest 'https://nodejs.org/dist/v25.8.1/node-v25.8.1-x64.msi' ^
 -OutFile '%temp%\node.msi'"

echo Installing Node Silently...
msiexec /i "%temp%\node.msi" /qn /norestart ADDLOCAL=ALL

echo Verifying Node...
node -v
npm -v

timeout /t 2 >nul

:: ===========================================
:: CREATE INSTALL DIRECTORY
:: ===========================================

set installDir=%appdata%\DaddyOfManagement
if not exist "%installDir%" mkdir "%installDir%"

:: ===========================================
:: DOWNLOAD YOUR ZIP
:: ===========================================

echo.
echo [2/4] Downloading Application...

powershell -Command ^
"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
 Invoke-WebRequest '' ^
 -OutFile '%temp%\dom.zip'"

:: ===========================================
:: EXTRACT ZIP
:: ===========================================

echo [3/4] Extracting Files...
powershell -Command "Expand-Archive '%temp%\dom.zip' '%installDir%' -Force"

timeout /t 1 >nul

:: ===========================================
:: REGISTER STARTUP
:: ===========================================

echo [4/4] Registering Startup...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" ^
/v "DaddyOfManagement" ^
/t REG_SZ ^
/d "\"%installDir%\Daddy Of Management.exe\"" ^
/f

:: ===========================================
:: CREATE DESKTOP SHORTCUT
:: ===========================================

set shortcutPath=%userprofile%\Desktop\Daddy Of Management.lnk

powershell ^
$WshShell = New-Object -ComObject WScript.Shell; ^
$Shortcut = $WshShell.CreateShortcut('%shortcutPath%'); ^
$Shortcut.TargetPath = '%installDir%\Daddy Of Management.exe'; ^
$Shortcut.WorkingDirectory = '%installDir%'; ^
$Shortcut.IconLocation = '%installDir%\logo.ico'; ^
$Shortcut.Save()

cls
echo ===============================================================
echo                INSTALLATION COMPLETE
echo ===============================================================
echo.
echo Daddy Of Management is Ready.
pause
exit
