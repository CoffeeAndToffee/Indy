@echo off

REM ****************************************************************************
REM 
REM Author : Malcolm Smith, MJ freelancing
REM          http://www.mjfreelancing.com
REM 
REM Pre-requisites:  \Lib\Source\ZLib must contain the ZLIB OBJ files
REM                  \Lib\Packages\RADStudio_2007 contains the project / res files
REM                  \Lib\Source contains the pas / inc files
REM 
REM ****************************************************************************

..\computil SetupC11
if exist setenv.bat call setenv.bat
if exist setenv.bat del setenv.bat > nul

if (%NDC11%)==() goto enderror
if not exist %NDC11%\bin\dcc32.exe goto endnocompiler

if not exist ..\..\..\C11\*.* md ..\..\..\C11 >nul
if exist ..\..\..\C11\*.* call ..\clean.bat ..\..\..\C11\

copy IndySystem.dpk ..\..\..\C11 > nul 
copy *IndySystem.cfg1 ..\..\..\C11 > nul
copy *IndySystem.cfg2 ..\..\..\C11 > nul
copy *IndyCore.dpk ..\..\..\C11 > nul
copy *IndyCore.cfg1 ..\..\..\C11 > nul
copy *IndyCore.cfg2 ..\..\..\C11 > nul
copy *IndyProtocols.dpk ..\..\..\C11 > nul
copy *IndyProtocols.cfg1 ..\..\..\C11 > nul
copy *IndyProtocols.cfg2 ..\..\..\C11 > nul

cd ..\..\Source 
copy zlib\*.obj ..\..\C11 > nul
copy *.res ..\..\C11 > nul
copy *.pas ..\..\C11 > nul
copy *.dcr ..\..\C11 > nul
copy *.inc ..\..\C11 > nul

cd ..\..\C11


REM ************************************************************
REM Compile IndySystem - Round 1
REM ************************************************************
copy IndySystem.cfg1 IndySystem.cfg > nul
%NDC11%\bin\dcc32.exe /B IndySystem.dpk
if errorlevel 1 goto enderror2


REM ************************************************************
REM Compile IndySystem - Round 2
REM ************************************************************
del IndySystem.cfg > nul
copy IndySystem.cfg2 IndySystem.cfg > nul
%NDC11%\bin\dcc32.exe /B IndySystem.dpk
if errorlevel 1 goto enderror2


REM ************************************************************
REM Compile IndyCore - Round 1
REM ************************************************************
copy IndyCore.cfg1 IndyCore.cfg > nul
%NDC11%\bin\dcc32.exe /B IndyCore.dpk
if errorlevel 1 goto enderror2


REM ************************************************************
REM Compile IndyCore - Round 2
REM ************************************************************
del IndyCore.cfg > nul
copy IndyCore.cfg2 IndyCore.cfg > nul
%NDC11%\bin\dcc32.exe /B IndyCore.dpk
if errorlevel 1 goto enderror2


REM ************************************************************
REM Compile dclIndyCore - Round 1
REM ************************************************************
copy dclIndyCore.cfg1 dclIndyCore.cfg > nul
%NDC11%\bin\dcc32.exe /B dclIndyCore.dpk
if errorlevel 1 goto enderror2


REM ************************************************************
REM Compile IndyProtocols - Round 1
REM ************************************************************
copy IndyProtocols.cfg1 IndyProtocols.cfg > nul
%NDC11%\bin\dcc32.exe /B IndyProtocols.dpk
if errorlevel 1 goto enderror2


REM ************************************************************
REM Compile IndyProtocols - Round 2
REM ************************************************************
del IndyProtocols.cfg > nul
copy IndyProtocols.cfg2 IndyProtocols.cfg > nul
%NDC11%\bin\dcc32.exe /B IndyProtocols.dpk
if errorlevel 1 goto enderror2


REM ************************************************************
REM Compile dclIndyProtocols - Round 1
REM ************************************************************
copy dclIndyProtocols.cfg1 dclIndyProtocols.cfg > nul
%NDC11%\bin\dcc32.exe /B dclIndyProtocols.dpk
if errorlevel 1 goto enderror2


REM ************************************************************
REM Set all files we want to keep with the R attribute then 
REM delete the rest before restoring the attribute
REM ************************************************************
attrib +r Id*.hpp
attrib +r *.bpl
attrib +r Indy*.bpi
attrib +r Indy*.lib
attrib +r indysystem.res
attrib +r indycore.res
attrib +r indyprotocols.res
del /Q /A:-R *.* > nul
attrib -r Id*.hpp
attrib -r *.bpl
attrib -r Indy*.bpi
attrib -r Indy*.lib
attrib -r indysystem.res
attrib -r indycore.res
attrib -r indyprotocols.res

cd ..\Lib\Packages\RADStudio_2007
goto endok

:enderror2
cd ..\Lib\Packages\RADStudio_2007

:enderror
echo Error!
pause
goto endok

:endnocompiler
echo C++Builder 11 Compiler Not Present!
goto endok

:endok
