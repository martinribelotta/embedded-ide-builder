@echo off
set BASE=%~dp0
set BASE_MSYS=%BASE%\msys
set PATH=%BASE%\bin

mingw-get update

set packages=
SetLocal EnableDelayedExpansion
for /F "delims=" %%i in (packages.txt) do set packages=!packages! %%i

echo Installing %packages%
mingw-get install %packages%
EndLocal

:1
copy/Y msys.bat.in %BASE%\msys\msys.bat
copy/Y start-ide.bat.in %BASE%\msys\start-ide.bat

echo "Done"
pause
