@ECHO OFF

ECHO Please enter USB controller busparams
ECHO The value is usually either 0.13.0 or 0.20.0
SET /p busParam="Enter USB controller busparams: "
ECHO USB Controller busparams is %busParam%
ECHO.

ECHO Enable WinDbg
bcdedit /set {default} debug on
bcdedit /set {default} bootdebug on
bcdedit /set {default} testsigning on
bcdedit /set {default} nointegritychecks on
bcdedit /dbgsettings usb targetname:usb
bcdedit /set {dbgsettings} busparams %busParam%
ECHO Debug Target Name : usb (lower case)
pause