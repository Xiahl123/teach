# android 配置文件
sdk 路径：/home/xiahl/Android/Sdk
模拟器路径：/home/xiahl/Android/Sdk/emulator
## 安装adb的工具
sudo apt update (更新软件包)
sudo apt install android-tools-adb（安装adb的工具）
adb devices（查看连接的设备）
# 将用户添加到串口组中
## 查看usb连接设备(一般2717**)
lsusb
##添加文件配置规则
新建并打开文件：sudo gedit /etc/udev/rules.d/70-android.rules
给文件添加权限：sudo chmod a+rx /etc/udev/rules.d/70-android.rules
重启服务：sudo /etc/init.d/udev restart
进入Android/Sdk/platform-tools：
>sudo ./adb kill-server
>sudo ./adb start-server
>sudo ./adb devices
#最后重新插拔usb,触发手机询问是否允许调试


