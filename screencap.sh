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
    mkdir ~/screen_from_phone
    cd ~/screen_from_phone
    echo "输入文件名"
    read name
    adb -s $var shell screencap -p /sdcard/$name.png 
    adb -s $var pull /sdcard/$name.png
    open .
    open $name.png
    ftc $name.png
    cd -

    #read -p "adb -s $var " cmd
    #adb -s $var $cmd
fi

