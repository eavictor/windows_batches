@echo off

REM **************************************************************************************
REM *                                                                                    *
REM * This Script is for adding Intel RST or Virt-IO driver into Windows Install Media.  *
REM * The Script will create a temporary folder "C:\Win10USB" during process.            *
REM *                                                                                    *
REM *                                                                                    *
REM * 1. Use "Rufus" to create a bootable Windows 10 Install USB Media.                  *
REM *    Note: Select [GPT] option if platform is KabyLake or later.                     *
REM *                                                                                    *
REM * 2. Modify those 3 parameters (driver_path, install_media_path and windows_10_ver). *
REM *                                                                                    *
REM * 3. Run this script as administrator.                                               *
REM *                                                                                    *
REM *                                                                                    *
REM * driver_path        : The dirver folder you want to add into Windows Install Media. *
REM * install_media_path : Bootable USB Windows 10 Install Media, English only.          *
REM *                                                                                    *
REM **************************************************************************************



ECHO Enter USB Install Media Path.
ECHO For example, if your USB label is D, then you have to enter D:\
SET /p install_media_path="Enter USB Path: "
ECHO.



ECHO Enter the path of driver you want to inject into USB install media.
SET /p driver_path="Enter Driver Path: "
ECHO.



REM Create and change working directory to C:\Win10USB
mkdir C:\Win10USB
cd C:\Win10USB



REM Copy boot.wim and install.wim from USB Stick
copy %install_media_path%sources\install.wim C:\Win10USB
copy %install_media_path%sources\boot.wim C:\Win10USB



REM echo Step extra: Get index information
REM dism /get-wiminfo /wimfile:install.wim
REM dism /get-wiminfo /wimfile:boot.wim



REM Patch boot.wim
REM Index 1: Windows PE
REM Index 2: Windows Setup
for /l %%x in (1, 1, 2) do (
    mkdir C:\Win10USB\boot
    dism /mount-image /imagefile:boot.wim /index:%%x /mountdir:boot
    dism /image:boot /add-driver /driver:%driver_path% /forceunsigned /recurse
    dism /unmount-wim /mountdir:boot /commit
    del C:\Win10USB\boot /s /q
    rmdir C:\Win10USB\boot /s /q
)



REM Patch install.wim
REM Index 1: Windows 10 S
REM Index 2: Windows 10 S N
REM Index 3: Windows 10 Home
REM Index 4: Windows 10 Home N
REM Index 5: Windows 10 Home Single Language
REM Index 6: Windows 10 Education
REM Index 7: Windows 10 Education N
REM Index 8: Windows 10 Pro
REM Index 9: Windows 10 Pro N
REM Index 10: Windows 10 Pro for Workstation
REM Index 11: Windows 10 Pro for Workstation N
for /l %%x in (1, 1, 11) do (
    mkdir C:\Win10USB\windows
    mkdir C:\Win10USB\winre
    dism /mount-image /imagefile:install.wim /index:%%x /mountdir:windows
    dism /image:windows /add-driver /driver:%driver_path% /forceunsigned /recurse
    dism /mount-image /imagefile:C:\Win10USB\windows\windows\system32\recovery\winre.wim /index:1 /mountdir:winre
    dism /image:winre /add-driver /driver:%driver_path% /forceunsigned /recurse
    dism /unmount-wim /mountdir:winre /commit
    dism /unmount-wim /mountdir:windows /commit
    del C:\Win10USB\windows /s /q
    rmdir C:\Win10USB\windows /s /q
    del C:\Win10USB\winre /s /q
    rmdir C:\Win10USB\winre /s /q
)



REM Rename Original Files
ren %install_media_path%sources\install.wim install.wim-backup
ren %install_media_path%sources\boot.wim boot.wim-backup

REM Copy Patched Files to USB
copy C:\Win10USB\install.wim %install_media_path%sources\install.wim
copy C:\Win10USB\boot.wim %install_media_path%sources\boot.wim

REM Clean Up
cd C:\
del C:\Win10USB /s /q
rmdir C:\Win10USB /s /q

pause