@echo off
rem LSS <
rem GTR >
rem EQU ==
rem NEQ !=
rem LEQ <=
rem GEQ >=

chcp 65001
setlocal ENABLEDELAYEDEXPANSION
set emptychar=∙
set headchar=█
set segmchar=▒
set foodchar=♥
cls

rem global
rem window
set /a w=10
set /a h=10

set /a w-=1
set /a h-=1
rem mode con:cols=%w% lines=%h%

rem maximum length of the snake
set /a maxl=23
rem current length of the snake
set /a curl=3

rem ------------------------------------------------------------------

echo use ENG
echo press 'd' to right
echo press 'a' to left
echo press 'w' to up
echo press 's' to down
pause

rem init snake
set /a i=0
:INITARR
set /a x[%i%]=%i%
set /a y[%i%]=0
set /a i+=1
if %i% LSS %curl% goto INITARR

rem init food
set lableret=ret
goto RNDFOOD
:ret

set key=s

rem main loop
:LOOP
cls

rem cls boof
set /a cy=0
:CYL
set /a cx=0
:CXL
set /a b[%cy%L%cx%]=-1
set /a cx+=1
if %cx% LEQ %w% goto CXL
set /a cy+=1
if %cy% LEQ %h% goto CYL
rem ------------------------------------------------------------------

rem set snake to boof
set /a b[!y[0]!L!x[0]!]=0
set /a i=1
:SSNAKEB
set /a b[!y[%i%]!L!x[%i%]!]=1
set /a i+=1
if %i% LSS %curl% goto SSNAKEB
rem ------------------------------------------------------------------

rem set food to boof
set /a b[%foody%L%foodx%]=2
rem ------------------------------------------------------------------

rem draw boof
set /a cy=0
:CYD
set /a cx=0
set str=
:CXD
if !b[%cy%L%cx%]! EQU -1 ((set str=%str%%emptychar%%emptychar%) & goto ECCXD)
if !b[%cy%L%cx%]! EQU 0 ((set str=%str%%headchar%%headchar%) & goto ECCXD)
if !b[%cy%L%cx%]! EQU 1 ((set str=%str%%segmchar%%segmchar%) & goto ECCXD)
if !b[%cy%L%cx%]! EQU 2 ((set str=%str%%foodchar%%foodchar%) & goto ECCXD)
:ECCXD
set /a cx+=1
if %cx% LEQ %w% goto CXD
set /a cy+=1
echo %str%
if %cy% LEQ %h% goto CYD
rem ------------------------------------------------------------------

rem show pts
set /a pts=%curl%-3
echo pts %pts%

rem move snake segm
set /a i=%curl%
:MSNAKES
set /a i-=1
set /a previ=%i%-1
if %i% NEQ 0 ((set /a x[%i%]=!x[%previ%]!) & (set /a y[%i%]=!y[%previ%]!))
if %i% GTR 0 goto MSNAKES
rem ------------------------------------------------------------------

rem management
set pastkey=%key%
choice /C WSAD /D !pastkey! /T 1

if "!ERRORLEVEL!"=="1" set key=w& goto CHECKKEY
if "!ERRORLEVEL!"=="2" set key=s& goto CHECKKEY
if "!ERRORLEVEL!"=="3" set key=a& goto CHECKKEY
if "!ERRORLEVEL!"=="4" set key=d& goto CHECKKEY

:CHECKKEY
if "%key%"=="d" (
    @if not "%pastkey%"=="a" (
        (@if %x[0]% LSS %w% (set /a x[0]+=1) else (set /a x[0]=0)) & goto ENDMNG
    )
)
if "%pastkey%"=="d" (
    @if "%key%"=="a" (
        (@if %x[0]% LSS %w% (set /a x[0]+=1) else (set /a x[0]=0)) & set key=d& goto ENDMNG
    )
)

if "%key%"=="a" (
    @if not "%pastkey%"=="d" (
        (@if %x[0]% GTR 0 (set /a x[0]-=1) else (set /a x[0]=%w%)) & goto ENDMNG
    )
)
if "%pastkey%"=="a" (
    @if "%key%"=="d" (
        (@if %x[0]% GTR 0 (set /a x[0]-=1) else (set /a x[0]=%w%)) & set key=a& goto ENDMNG
    )
)

if "%key%"=="s" (
    @if not "%pastkey%"=="w" (
        (@if %y[0]% LSS %h% (set /a y[0]+=1) else (set /a y[0]=0)) & goto ENDMNG
    )
)
if "%pastkey%"=="s" (
    @if "%key%"=="w" (
        (@if %y[0]% LSS %h% (set /a y[0]+=1) else (set /a y[0]=0)) & set key=s& goto ENDMNG
    )
)

if "%key%"=="w" (
    @if not "%pastkey%"=="s" (
        (@if %y[0]% GTR 0 (set /a y[0]-=1) else (set /a y[0]=%h%)) & goto ENDMNG
    )
)
if "%pastkey%"=="w" (
    @if "%key%"=="s" (
        (@if %y[0]% GTR 0 (set /a y[0]-=1) else (set /a y[0]=%h%)) & set key=w& goto ENDMNG
    )
)

:ENDMNG
rem ------------------------------------------------------------------

rem check food
if %x[0]% EQU %foodx% if %y[0]% EQU %foody% (
set /a curl+=1
set lableret=CHWIN
goto RNDFOOD
)
rem ------------------------------------------------------------------

rem check game over
set /a hx=%x[0]%
set /a hy=%y[0]%
if !b[%hy%L%hx%]! EQU 1 (
set endmsg=GAME OVER   
goto ENDGAME
)

if !b[%hy%L%hx%]! EQU 0 (
set endmsg=GAME OVER   
goto ENDGAME
)
rem ------------------------------------------------------------------

rem check win
:CHWIN
if %curl% EQU %maxl% (
set endmsg=WIN    
goto ENDGAME
)
rem ------------------------------------------------------------------
goto LOOP



rem rnd food
:RNDFOOD
set /a foodx=(%RANDOM%*(%w%+1)/32768)
set /a foody=(%RANDOM%*(%h%+1)/32768)
goto %lableret%

rem end game
:ENDGAME
cls
echo %endmsg%
pause
exit