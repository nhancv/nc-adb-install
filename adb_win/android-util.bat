@ECHO off
adb devices
ECHO Command list:
ECHO 1. Open browser with url
ECHO 2. Force install apk
ECHO --------------------
SET /p commandNumber="Which command you want: "
IF %commandNumber%==1 GOTO :INSTALL_URL
IF %commandNumber%==2 GOTO :FORCE_INSTALL

GOTO :END

:INSTALL_URL
SET /p APK_URL="Enter the url to apk: "
adb shell am start -a android.intent.action.VIEW -d '%APK_URL%'
GOTO :END

:FORCE_INSTALL
SET /p APK_URL="Enter the path to apk: "

FOR /F "tokens=* USEBACKQ" %%F IN (`aapt dump badging %APK_URL%`) DO (
SET APK_INFO=%%F
GOTO :FORCE_INSTALL_BREAK
)
:FORCE_INSTALL_BREAK

CALL :FIND_POS
CALL SET APK_PACKAGE=%%APK_INFO:~15,%pos%%%
ECHO %APK_INFO%

ECHO ---------begin---------

ECHO force-stop: %APK_PACKAGE%
adb shell am force-stop %APK_PACKAGE%

ECHO clear: %APK_PACKAGE%
adb shell pm clear %APK_PACKAGE%

ECHO uninstall: %APK_PACKAGE%
adb uninstall %APK_PACKAGE%

ECHO install: %APK_URL%
adb install -r %APK_URL%

ECHO start: %APK_PACKAGE%
adb shell monkey -p %APK_PACKAGE% -c android.intent.category.LAUNCHER 1

ECHO ---------end---------
GOTO :END

:FIND_POS
Set "str1=%APK_INFO%"
Set "sstr=\' versionCode="
SET stemp=%str1%&SET pos=0
:FIND_POS_LOOP
SET /a pos+=1
echo %stemp%|FINDSTR /b /c:"%sstr%" >NUL
IF ERRORLEVEL 1 (
SET stemp=%stemp:~1%
IF DEFINED stemp GOTO FIND_POS_LOOP
SET pos=0
)
SET /a pos-=16
EXIT /B 0

:END
PAUSE
