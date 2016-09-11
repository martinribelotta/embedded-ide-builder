set PATH=%~dp0\bin

mingw-get update

set packages=
SetLocal EnableDelayedExpansion
for /F "delims=" %%i in (packages.txt) do set packages=!packages! %%i

echo Installing %packages%
mingw-get install %packages%
EndLocal

:1
pause