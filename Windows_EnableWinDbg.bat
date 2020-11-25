@ECHO OFF

ECHO Please enter USB controller busparams
ECHO The value is usually either 0.13.0 or 0.20.0
ECHO 0.13.0 usually assigned to Thunderbolt.
SET /p busParam="Enter USB controller busparams: "
ECHO USB Controller busparams is %busParam%
ECHO.

REM Enable WinDBG on Windows Recovery Environment
REM 1. list all sections.
REM bcdedit /enum all
REM 2. check description "Windows Recovery Environment"
REM 3. see identifier uuid. e.g. {915b4b11-53f4-11e8-8b80-84cd3e685088}
REM 4. Enable debug as below.
REM bcdedit /set {915b4b11-53f4-11e8-8b80-84cd3e685088} debug on
REM bcdedit /set {915b4b11-53f4-11e8-8b80-84cd3e685088} testsigning on
REM bcdedit /set {915b4b11-53f4-11e8-8b80-84cd3e685088} nointegritychecks on

ECHO Enable WinDbg
bcdedit /bootdebug {bootmgr} on
bcdedit /bootdebug on
bcdedit /debug on
bcdedit /set {default} debug on
bcdedit /set {default} bootdebug on
bcdedit /set {default} testsigning on
bcdedit /set {default} nointegritychecks on
bcdedit /dbgsettings usb targetname:usb
bcdedit /set {dbgsettings} busparams %busParam%
ECHO Debug Target Name : usb (lower case)
pause
