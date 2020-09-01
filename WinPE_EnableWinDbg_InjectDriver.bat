@ECHO OFF

ECHO Please insert Windows USB install media or Windows PE USB media.
ECHO If USB WinPE drive letter is D, input D:\
SET /p usbLabel="Enter USB Driver Label: "
ECHO Driver Letter is %usbLabel%
ECHO.

ECHO Please enter USB controller busparams
ECHO The value is usually either 0.13.0 or 0.20.0
SET /p busParam="Enter USB controller busparams: "
ECHO USB Controller busparams is %busParam%
ECHO.

ECHO Please enter F6 Driver path
SET /p driver="Enter F6 Driver path: "
ECHO Driver path is %driver%
ECHO.


ECHO 1. Inject driver
SET wimFolder=C:\Win10USB
mkdir %wimFolder%
dism /mount-image /imagefile:%usbLabel%sources\boot.wim /index:1 /mountdir:%wimFolder%
dism /image:%wimFolder% /add-driver /driver:%driver% /forceunsigned /recurse
dism /unmount-wim /mountdir:%wimFolder% /commit
del %wimFolder% /s /q

ECHO 2. Switch drive
cd /D %usbLabel%efi\microsoft\boot

ECHO 3. Enable WinDbg
bcdedit /store .\bcd /set {default} debug on
bcdedit /store .\bcd /set {default} bootdebug on
bcdedit /store .\bcd /set {default} testsigning on
bcdedit /store .\bcd /set {default} nointegritychecks on
bcdedit /store .\bcd /dbgsettings usb targetname:usb
bcdedit /store .\bcd /set {dbgsettings} busparams %busParam%
ECHO Debug Target Name : usb (lower case)
pause