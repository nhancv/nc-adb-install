@ECHO off
adb devices
ECHO Command list:
ECHO 1. Open browser with url
ECHO 2. Force install apk
ECHO --------------------
SET /p commandNumber="Which command you want? "
IF %commandNumber%==1 GOTO :INSTALL_URL
IF NOT %commandNumber%==1 GOTO :FORCE_INSTALL

:INSTALL_URL


GOTO :END

:FORCE_INSTALL
SET /p PATH_NAME="Enter the path to apk: "

FOR /F "tokens=* USEBACKQ" %%F IN (`aapt dump badging C:\adb_win\avb-staging_7.apk`) DO (
SET APK_INFO=%%F
CALL :FIND_POS
CALL SET APK_PACKAGE=%%APK_INFO:~15,%pos%%%
GOTO :FORCE_INSTALL_BREAK
)
:FORCE_INSTALL_BREAK
ECHO %APK_INFO%

ECHO ---------begin---------

CALL :FORCE_STOP
CALL :CLEAR_APP
CALL :UNINSTALL
CALL :INSTALL
CALL :START_APP

ECHO ---------end---------
GOTO :END

:FORCE_STOP
ECHO force-stop: %APK_PACKAGE%
adb shell am force-stop %APK_PACKAGE%
EXIT /B 0
:CLEAR_APP
ECHO clear: %APK_PACKAGE%
adb shell pm clear %APK_PACKAGE%
EXIT /B 0
:UNINSTALL
ECHO uninstall: %APK_PACKAGE%
adb uninstall %APK_PACKAGE%
EXIT /B 0
:INSTALL
ECHO install: %APK_PACKAGE%
adb install -r %APK_PACKAGE%
EXIT /B 0
:START_APP
ECHO start: %APK_PACKAGE%
adb shell monkey -p %APK_PACKAGE% -c android.intent.category.LAUNCHER 1
EXIT /B 0

:FIND_POS
Set "str1=%APK_INFO%"
Set "sstr=\' versionCode="
SET stemp=%str1%&SET pos=0
:FIND_POS_loop
SET /a pos+=1
echo %stemp%|FINDSTR /b /c:"%sstr%" >NUL
IF ERRORLEVEL 1 (
SET stemp=%stemp:~1%
IF DEFINED stemp GOTO FIND_POS_loop
SET pos=0
)
SET /a pos-=16
EXIT /B 0

:END
PAUSE
