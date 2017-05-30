echo "---------begin---------"

apk_path=$1
echo "apk file: " $apk_path
./aapt dump badging $1 | grep package
package=$(./aapt dump badging "$*" | awk '/package/{gsub("name=|'"'"'","");  print $2}')
activity=$(./aapt dump badging "$*" | awk '/activity/{gsub("name=|'"'"'","");  print $2}')

echo "force-stop: $package"
./adb shell am force-stop $package

echo "clear: $package"
./adb shell pm clear $package

echo "uninstall: $package"
./adb uninstall $package

echo "install: $apk_path"
./adb install -r $apk_path

echo "start: $activity"
./adb shell am start -n $package/$activity

echo "---------end---------"