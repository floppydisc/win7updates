@echo off
rem hier die gewuenschten KBs eingeben die deinstalliert werden sollen (durch leerzeichen getrennt)
set UNINST_KBS=KB3035583
rem hier die nur die KB - NUMMERN also ohne "KB" eingeben:
set HIDE_KBS=3035583

set INSTALLED_UPDATES=%cd%\installed_updates.txt
set UNINSTALLED_UPDATES=%cd%\uninstalled_updates.txt
set UPDATE_INFO=%TMP%\tmp_update_info.txt

set findkb="false"
set uninstalled="false"

echo (1/3)Erstelle Liste installierter Updates nach
echo %installed_updates%
start /WAIT /B dism /online /get-packages /format:table > %installed_updates%
echo\
echo -----------------------------
echo (2/3)Suche und deinstalliere Updates (%UNINST_KBS%)

for %%K in (%UNINST_KBS%) do (
	echo Suche %%K
	set findkb=false

	echo %INSTALLED_UPDATES% | findstr /B /R /C:"\<Package_for_%%kb[^\|]*" >%UPDATE_INFO%
	set /p pkg_info=<%UPDATE_INFO%

	for /f "tokens=1 delims= " %%G IN ("%pkg_info%") DO (
		set findkb=true
		echo %%K gefunden - wird deinstalliert
		echo %pkg_info% >>%UNINSTALLED_UPDATES%
		start /WAIT /B dism /online /Remove-Package /PackageName:%%G /quiet /norestart
	)

	if %findkb%=="true" ( 
		echo\
	) ELSE (
		echo Update %%K nicht gefunden.
		echo\
	)
)
echo\
echo -----------------------------
echo (3/3) Updates ausblenden %HIDE_KBS%
cscript.exe HideWindowsUpdates.vbs %HIDE_KBS%
echo\
echo Bitte Neustarten damit Aenderungen wirksam werden.
PAUSE