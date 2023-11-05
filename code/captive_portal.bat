@echo off
cd /D "%~dp0"
goto get_ssid

:get_ssid
for /f "tokens=2 delims=:" %%i in ('netsh wlan show interface ^| findstr /i "SSID"') do (set "myssid=%%i"&goto check_ssid)
:check_ssid
set myssid=%myssid:MEIAM WIFI RESIDANTS=%
for /f "tokens=* delims= " %%a in ("%myssid%") do set myssid=%%a
if "%myssid%"=="" goto check_ini
echo Not MEIAM WIFI RESIDANTS wifi
goto end

:check_ini
if "%~1"=="" goto check_portal
if exist "%~1" (
	goto read
)
goto check_portal

:read
for /f "tokens=1,2 delims==: usebackq" %%a in ("%~1") do (
	if %%a==username (
		set _%%a=%%b
	)
	if %%a==password (
		set _%%a=%%b
	)
)
goto check_portal

:check_portal
for /F "delims=" %%I in ('curl -s http://detectportal.firefox.com/canonical.html') do (set captive="%%I")
set captive="%captive:"='%"
if %captive%=="'<meta http-equiv='refresh' content='0;url=https://support.mozilla.org/kb/captive-portal'/>'" (
	echo "Already connected"
	goto end
)
for /F "delims=' tokens=4" %%I in (%captive%) do (set captive=%%I)
goto choice

:choice
if not defined _username goto request__username
if not defined _password goto request__password
set _username=%_username: =%
set _password=%_password: =%
set _username=%_username:"=%
set _password=%_password:"=%
goto login

:request__username
set /p "_username=Username: "
goto choice

:request__password
set /p "_password=Password: "
goto choice

:login
curl -s %captive%
for /F "delims=? tokens=1,2" %%a in ("%captive%") do (set captive=%%a&set magic=%%b)
:lw
if "%captive:~-1%"=="/" goto elw
set captive=%captive:~0,-1%
goto lw
:elw
for /F "delims= usebackq" %%I in (`curl -d "4Tredir=http://detectportal.firefox.com/canonical.html&magic=%magic%&username=%_username%&password=%_password%" -H "Content-Type: application/x-www-form-urlencoded" -X POST -s %captive%`) do (set captive="%%I")
set captive="%captive:"='%"
if %captive%==%captive:fail=% goto end
goto fail

:fail
echo Connexion failed
echo Fallback: manual registration
set _username=
set _password=
set magic=
set captive=
goto check_portal


:end
echo Connected!
set _username=
set _password=
set magic=
set captive=
rem pause
