@ECHO OFF
BREAK ON

:: set PL/M tools and sources paths
set SOURCES=..\SOURCE

if %PLM80% == "" goto nodef
set PLMBIN=%PLM80%\BIN
set PLMLIB=%PLM80%\LIB
goto clearprev

:nodef
:: !!! predefined path not found, use default !!!
set PLMBIN=C:\PLMTOOL\BIN
set PLMLIB=C:\PLMTOOL\LIB

:clearprev
:: clear previous files
del %SOURCES%\*.obj
del %SOURCES%\*.lst
del bolder.com


:: set sources and plm80 paths with ISIS-II style
set :F0:=%PLMBIN%
set :F1:=%SOURCES%
set :F2:=%PLMLIB%

cls
%PLMBIN%\ASM80 :f1:grapp.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:ctrl.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:cons.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:rsrc.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:timer.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:sound.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:fileio.m80
if errorlevel == 1 goto error


%PLMBIN%\PLM80 :f1:labir.plm PAGEWIDTH(120)
if errorlevel == 1 goto error

%PLMBIN%\PLM80 :f1:bolder.plm PAGEWIDTH(120)
if errorlevel == 1 goto error

echo ===========================================
echo = Yeehaw! All compiled! No Errors! Ready! =
echo ===========================================

pause
cls
@ECHO ON

%PLMBIN%\link @:f1:link.txt
%PLMBIN%\LOCATE :f1:bolder.lnk TO :f1:bolder.kz CODE(100H) STACKSIZE(100) MAP PRINT(:f1:bolder.tra)
%PLMBIN%\OBJCPM :f1:bolder.kz
@ECHO OFF
copy /b %SOURCES%\bolder.com .\bolder.com
if errorlevel == 1 goto error

:: copy to image file of HDD, for emulator EMU80
:: if exist "D:\EMU80\PK8000\cf.cpm" %PLMBIN%\c8000w.exe -r "D:\EMU80\PK8000\cf.cpm" A: bolder.com

goto end

:error
echo ######################################
echo ######################################
echo ######### AN ERROR OCCURED! ##########
echo ######################################
echo ######################################

:end
pause
del %SOURCES%\*.lst
del %SOURCES%\*.obj
del %SOURCES%\bolder.kz
del %SOURCES%\bolder.lin
del %SOURCES%\bolder.lnk
del %SOURCES%\bolder.sym
del %SOURCES%\bolder.tra
del %SOURCES%\bolder.com
