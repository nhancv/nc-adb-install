cd "${0%/*}"
apk_url=$1
./adb shell am start -a android.intent.action.VIEW -d $apk_url