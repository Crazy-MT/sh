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
    echo "Please complete the order :"
    read -p "adb -s $var " cmd
    adb -s $var $cmd
fi