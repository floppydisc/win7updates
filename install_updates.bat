@echo off
FOR /f "tokens=*" %%g in ('dir /on /b /s /a:d "%cd%"') DO (

	echo -------- Installiere Updates cab/msu aus %%g

rem notizen zum escapen des dir befehls mit ^(, ^>, und ^) (=umleiten der fehlermeldung "Datei nicht gefunden") finden sich auf
rem http://www.robvanderwoude.com/battech_redirection.php

rem cab/CAB dateien mit dism installieren
	rem echo ++++ suche cab dateien
	
	FOR /f "tokens=*" %%c in ('^(dir /b /on "%%g\*.cab" 2^> NUL^)') DO (
		echo Installiere %%c
		start "%%c" /B /ABOVENORMAL /wait dism /online /add-package /packagepath:"%%g\%%c" /NoRestart /Quiet
		echo.
	)

rem msu/MSU dateien mit wusa installieren
	rem echo ++++ suche msu dateien
	
	FOR /f "tokens=*" %%m in ('^(dir /b /on "%%g\*.msu" 2^> NUL^)') DO (
		echo Installiere %%m
		start "%%m" /ABOVENORMAL /wait wusa "%%g\%%m" /quiet /norestart
		echo.
	)
)

echo -------- Aufraeumen...
start /wait /B /ABOVENORMAL dism /online /cleanup-image /spsuperseded

echo Fertig.
PAUSE