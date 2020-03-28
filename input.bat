@echo off
setlocal enableextensions enabledelayedexpansion
:LOOPP
set /p str=
set str=!str:~0,1!
echo %str%> input.txt
goto LOOPP