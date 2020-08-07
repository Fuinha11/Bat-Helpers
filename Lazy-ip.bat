@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
:--------------------------------------   

echo Lazy IP setter.
echo/
echo Default driver name is Ethernet.
set /p s="Do you wanna select driver? [y/n]: " 

set name="Ethernet"

IF /i "%s%" EQU "y" (
    netsh interface show interface
    set /p name="Type driver name: "
)

echo Lazy set your %name% IP.
echo Select your IP band from the option bellow:
echo     1- 10.0.140.x
echo     2- 192.168.0.x
echo     3- 10.128.7.x
echo     0- Dynamic
set /p band="Band selected: " 

IF "%band%"=="1" (
    netsh interface ipv4 set address name=%name% static 10.0.140.69 255.255.255.0 10.0.140.1
) ELSE IF "%band%"=="2" (
    netsh interface ipv4 set address name=%name% static 192.168.0.69 255.255.255.0 192.168.0.1
) ELSE IF "%band%"=="3" (
    netsh interface ipv4 set address name=%name% static 10.128.7.69 255.255.255.0 10.128.7.1
) ELSE (  
    netsh interface ipv4 set address name=%name% dhcp
)
echo Done.
pause 

