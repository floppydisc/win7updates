@echo off
rem hier die gewuenschten KBs eingeben die deinstalliert werden sollen (durch leerzeichen getrennt)
set UNINST_KBS=KB3035583
rem hier die nur die KB - NUMMERN also ohne "KB" eingeben:
set HIDE_KBS=3035583

set INSTALLED_UPDATES=%cd%\installed_updates.txt
set UNINSTALL_UPDATES=%cd%\uninstall_updates_found.txt
set UPDATE_INFO=%cd%\tmp_update_info.txt

set findkb="false"
set uninstalled="false"

echo (1/3)Erstelle Liste installierter Updates nach
echo %installed_updates%
del %installed_updates%
dism /online /get-packages /format:table > %installed_updates%
echo\
echo -----------------------------
echo (2/3)Suche und deinstalliere Updates (%UNINST_KBS%)

for %%K in (%UNINST_KBS%) do (
	echo Suche %%K
	set findkb=false

	type %INSTALLED_UPDATES% | findstr /B /R /C:"\<Package_for_%%K.*Installiert[^\|]*" >%UPDATE_INFO%
	
	rem echo liste installierter updates...	
	rem type %UPDATE_INFO%
	rem PAUSE
	for /f "tokens=*" %%r in (%UPDATE_INFO%) do (

		rem set /p pkg_info=<"%%r"
		rem echo R = %%r

		for /f "tokens=1 delims= " %%G IN (%%r) DO (
		echo deinstalliere %%r..
		PAUSE
			set findkb=true
			echo %%G gefunden - wird deinstalliert
			echo %%r >>%UNINSTALL_UPDATES%
			start /WAIT /B dism /online /Remove-Package /PackageName:%%G /quiet /norestart
		)

		if %findkb%=="true" ( 
			echo\
		) ELSE (
			echo Update %%K nicht am System gefunden.
			echo\
		)
	)
)
echo\
echo -----------------------------
echo (3/3) Updates ausblenden %HIDE_KBS%
cscript.exe HideWindowsUpdates.vbs %HIDE_KBS%
echo\
echo Bitte Neustarten damit Aenderungen wirksam werden.
PAUSE