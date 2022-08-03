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
	power=`adb -s $var shell dumpsys power | grep "Display Power: state="`
	
	POWER_ON="ON"
	if [[ $power == *$POWER_ON* ]]
	then
	    echo "亮屏"
	else
	    echo "未亮屏"
	    
		adb -s $var shell input keyevent 26
	fi
	
	sleep 1
	
	policy=`adb -s $var shell dumpsys window policy | grep "isStatusBarKeyguard"`
	#echo $policy
	
	POLICY_TRUE="true"
	if [[ $policy == *$POLICY_TRUE* ]]
	then
	    echo "未解锁"
	    adb -s $var shell input swipe 300 1920 300 0
		sleep 1
		## TODO 点击解锁坐标
		adb -s $var shell input tap 880 1340
		adb -s $var shell input tap 880 1340
		adb -s $var shell input tap 880 1340
		adb -s $var shell input tap 880 1340
	else
	    echo "解锁"
	fi
fi
