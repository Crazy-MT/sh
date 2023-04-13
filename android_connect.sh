#!/bin/bash

# 执行 adb devices 命令并将输出存储到 devices 变量中
devices=$(adb devices)

# 将 devices 变量中的输出转换为数组，并删除第一行标题行
IFS=$'\n' read -r -d '' -a devices_array <<< "${devices}" 
unset devices_array[0]

# 显示可用设备的列表
echo "可用设备列表："
for i in "${!devices_array[@]}"; do
  echo "$(($i)). ${devices_array[$i]%%$'\t'*}"
done

# 从用户那里获取所需设备的编号
echo -n "请选择设备的编号："
read device_num

# 获取所需设备的序列号并将其赋值给 DEVICE_ID 变量
DEVICE_ID=$(echo "${devices_array[$(($device_num))]}" | cut -f 1)

# 运行 adb 命令
echo "连接到设备：$DEVICE_ID"
adb -s $DEVICE_ID shell ip addr show wlan0 | grep 'inet\b' | awk '{print $2}' | cut -d/ -f1 | xargs -I % adb -s $DEVICE_ID connect %:5555

sleep 0.5

adb devices


adb -s $DEVICE_ID shell ip addr show wlan0 | grep 'inet\b' | awk '{print $2}' | cut -d/ -f1 | xargs -I % scrcpy -s %:5555 --display 1