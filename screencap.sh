#!/bin/bash
PS3="please select a device :"
array=($(adb devices | grep ".device$"))
i=0
length=${#array[@]}
while [ "$i" -lt "$length" ];do
    if 
        ((i%2!=0)) 
    then
        unset array[i]  
    fi
    ((i++))
done
((length++))
array[$length]=exit
select var in "${array[@]}" ;do
    break
done
if 
    [[ "$var" != "exit" ]]
then
    mkdir -p ~/screen_from_phone
    cd ~/screen_from_phone
    echo "输入文件名"
    read name
    adb -s "$var" shell screencap -p "/sdcard/$name.png"
    adb -s "$var" pull "/sdcard/$name.png"
    osascript -e 'on run argv' -e 'set the clipboard to (read (POSIX file (item 1 of argv)) as «class PNGf»)' -e 'end run' "$PWD/$name.png"
    echo "已复制到系统剪切板: $PWD/$name.png"
    cd -

    #read -p "adb -s $var " cmd
    #adb -s $var $cmd
fi
