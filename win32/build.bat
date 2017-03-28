@echo off
set QTIFW=C:\Qt\QtIFW2.0.3\bin\

set BASE=%~dp0
set BASE_MSYS=%BASE%\msys
set PATH=%BASE%\bin;%QTIFW%
set INSTALLER_PATH=%BASE%\installer

call build-msys.bat

set PATH=%BASE%\msys\bin
%BASE%\msys\bin\bash stage2.sh
echo "Done"
pause