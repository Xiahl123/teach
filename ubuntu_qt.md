# ubuntu_QT
包名：hkcrccockpit
## qt安装
sudo apt-get install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools qtcreator
## 使用ffmpeg
sudo apt-get install ffmpeg
使用ubuntu 22.04安装的是ffmpeg 4.4.2,会出现avdevice库找不到的情况,可以直接sudo apt-get install libavdevice-dev(直接安装这个库)
## qt5安装有一些组件不会自动安装,可以手动安装,比如multimedia
sudo apt-get insatll qtmultimedia5-dev
## 使用vtk
使用源码安装pcl1.8.1和vtk7.1
遇到bug查找：https://blog.csdn.net/dui845819593/article/details/128486864
## 打包
### 下载
使用工具linuxdeployqt  下载地址：https://github.com/probonopd/linuxdeployqt/releases
下载appimage,即是可执行文件
### 安装
进入download首先缩短名称：mv linuxdeployqt-6-x86_64.AppImage linuxdeployqt
然后添加权限：chmod 777 linuxdeployqt
最后移动到： sudo mv linuxdeployqt /usr/local/bin
测试安装：linuxdeployqt --version
### 如果出现fusu包错误，如下处理
https://github.com/AppImage/AppImageKit/wiki/FUSE
## 编译
colcon编译release：colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
##注意，一下打包方法仅适用于20.04,不适用于22.04
## 使用linuxdeployqt打包qt软件时，添加至bashrc的文件路径：https://blog.csdn.net/zyhse/article/details/106381937/
export PATH=/home/xiahl/Qt5.14.2/5.14.2/gcc_64/bin:$PATH
export LIB_PATH=/home/xiahl/Qt5.14.2/5.14.2/gcc_64/lib:$LIB_PATH
export PLUGIN_PATH=/home/xiahl/Qt5.14.2/5.14.2/gcc_64/plugins:$PLUGIN_PATH
export QML2_PATH=/home/xiahl/Qt5.14.2/5.14.2/gcc_64/qml:$QML2_PATH
### 添加完成后执行
source ~/.bashrc
### 测试是否添加成功
qmake -v   查看是否能输出PATH路径
## 新建一个文件夹用于打包软件
将release版本的软件复制到该目录下，然后执行以下命令：linuxdeployqt release名称 -appimage
如果终端报错：没有桌面文件和没有启动图标，之后再另行配置
在上述文件夹中生成了相应的lib目录，将需要的资源文件及配置文件复制到该目录下

### 测试是否打包成功
另起一个终端，在终端中临时去掉bashrc中的环境,使用export命令可以输出所有的环境变量
export PATH="去掉qt相关路径的PATH"
export LIB_PATH=""
export PLUGIN_PATH=""
export QML2_PATH=""
### 启动应用
./****
## 打包为deb文件
新建source,在source中新建DEBIAN,opt文件夹，将刚才打包生成的所有文件拷贝到此处opt中
### 配置桌面启动文件
修改defalut.desktop为：应用名.desktop
该文件内容（按注释修改）：
[Desktop Entry]
Type=Application
Name=My Test                    #应用的名字(快捷方式显示的文字)
Exec=/opt/Test/Test             #应用的执行路径(绝对路径)
Icon=/opt/Test/Test.png         #应用的图标(绝对路径)
Comment=This is my test         #说明信息
Terminal=true                   #是否允许在终端启动
### 在DEBIAN目录下新建control文件
内容如下：
Package: hkcrcCockpit
Version: 1.0.1
Section: utils
Priority: optional
Architecture: amd64
Depends:
Installed-Size: 512
Maintainer: xiahl@ust.hk
Description: this is a cockpit remote control
具体含义如下：
Package：包名。记住，后面卸载时候需要包名。
Version：应用版本。
Architecture：架构，我这里是amd64。
Maintainer：维护人员联系方式，看着办。
Description：软件包描述。
其他的，这里没用到，就不写了，自己百度吧。
### 添加shell脚本，配置软件执行环境，
在DEBIAN目录下创建postinst文件，添加下述信息，主要将.desktop文件copy到电脑目录下：
#!/bin/sh
chmod 777 /opt/Test/Test.desktop
cp /opt/Test/Test.desktop /usr/share/applications/
cp /opt/Test/Test.desktop ~/Desktop/
### 或许应该复制到：/home/xiahl/Desktop
### 创建卸载deb包之后的postrm文件
在DEBIAN目录下新建postrm文件，内容如下：
#!/bin/sh
rm /usr/share/applications/Test.desktop
rm ~/Desktop/Test.desktop
### 给DEBIAN添加权限755
sudo chmod -R 755 DEBIAN
### 最后回到source文件夹，执行dpkg -b . 生成路径/output.deb

## 问题解决
### 报错信息：无法创建 root/Desktop/****.desktop
手动到root下创建Desktop文件夹，然后卸载安装包，然后使用下面的方法清理残留
### 卸载安装包失败，提示：无法 删除~/Desktop/****.desktop
打开terminal:输入：sudo rm /var/lib/dpkg/info/包名*

## 22.04 qt 打包方法如下：
https://blog.csdn.net/linuxandroidwince/article/details/134649712

## QThread
### work继承QThread,把耗时工作放到run函数中执行
  只有run函数中的部分会运行在子线程中，其余部分运行在主线程，包括初始化等
  安全退出，使用信号让run函数return即可
### work继承QObject,使用moveToThread移动到子线程运行
  安全退出，使用：一个是QThread的finished信号对接QObject的deleteLater使得线程结束后，继承QObject的那个多线程类会自己销毁
  connect(this, &Controller::operate, worker, &Worker::doWork);

  


