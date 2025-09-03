@echo off
echo Starting Windows Webcam Capture...

where ffmpeg >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo FFmpeg is not installed or not in PATH.
    echo Please install FFmpeg or add it to your system PATH.
    echo Or install via: winget install FFmpeg
    pause
    exit /b
)
echo FFmpeg is installed. Continuing...

:: Get the first webcam name
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "Get-CimInstance Win32_PnPEntity | Where-Object { $_.Name -match 'Camera|Webcam' } | Select-Object -First 1 -ExpandProperty Name"`) do set CAMNAME=%%a

echo Using webcam: %CAMNAME%

REM Get WSL IP (assuming default)
REM set WSL_IP=172.17.0.1

REM Stream webcam to WSL nginx server
:loop
echo Capturing webcam and streaming to WSL...
ffmpeg -f dshow -i video="%CAMNAME%" ^
       -c:v libx264 ^
       -preset ultrafast ^
       -tune zerolatency ^
       -b:v 2500k ^
       -maxrate 2500k ^
       -bufsize 5000k ^
       -pix_fmt yuv420p ^
       -g 50 ^
       -keyint_min 15 ^
       -sc_threshold 0 ^
       -f flv ^
       rtmp://localhost/live/stream

echo Stream stopped. Restarting in 5 seconds...
timeout /t 5
goto loop
