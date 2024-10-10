# ubuntu
 创建文件夹： mkdir 文件夹名
 创建文件： touch 文件名（有可能权限不够）
 给文件添加权限 sudo chmod a+rx 文件名
 创建并打开文件： sudo gedit 文件名
 移除文件：sudo rm -rf 文件名（-r表示递归，f表示强制删除）
 修改文件名：sudo rm 旧名 新名（没有权限时，不能删除，需要-f））
 修改文件夹名：sudo rm 旧名/ 新名/
 快速启动：ALT+F2，输入软件名
***
## 安装包管理
安装新的包：sudo apt install ***
安装新的包：sudo apt-get install ***（-get会自动安装软件包需要的依赖包）
升级软件包：sudo apt upgrade
## 安装.run文件
chmod +x ***.run
./***.run
### 安装deb
sudo dpkg -i ***.deb 
### 卸载deb
sudo dpkg -r ***.deb

## 卸载
apt --fix-broken install
### 安装设置图标的文件AppImage application bundle 
直接运行即可：./****
***
## 获取root权限
sudo -s
sudo su root
***
## 修改文件权限
 给文件添加管理员权限：chmod 777 文件夹名
>chmod 777 * -R(全部子目录及文件权限改为 777)
>sudo chmod 600 ××× （只有所有者有读和写的权限）
>sudo chmod 644 ××× （所有者有读和写的权限，组用户只有读的权限）
>sudo chmod 700 ××× （只有所有者有读和写以及执行的权限）
>sudo chmod 666 ××× （每个人都有读和写的权限）
>sudo chmod 777 ××× （每个人都有读和写以及执行的权限）
***
## 新建文件
touch {文件名}
## 覆盖文件内容并重新输入，文件不存在则创建
echo "new line" > filename
## 追加文本内容
echo "add line" >> filename
## 添加到环境变量
source ***/setup.bash (临时添加到环境变量中，每次都需要添加)
sudo gedit ~/.bashrc(打开path配置文件，永久添加)
修改完后需要：source ~/.bashrc
## 查看环境变量
env 列出所有的环境变量
## 查看环境变量
### 加到PATH末尾
export PATH=$PATH:/path/to/your/dir
### 加到PATH开头
export PATH=/path/to/your/dir:$PATH
### 将 ros 环境加入到当前控制台的环境变量
echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
***
## cmake安装最新版，apt-get安装的不是最新版
<https://zhuanlan.zhihu.com/p/519732843>
## 读取文件中的命令
source filename
## 修改.bashrc文件
vim ~/.bashrc
### vim基础命令
i：在当前字符前插入。
I：在光标所在行的行首插入。
a：在当前字符后插入。
A：在光标所在行的行尾插入。
o：在当前行的下一行插入新的一行。
O：在当前行的上一行插入新的 一行
### vim退出编辑模式
Esc
### vim保存修改
:w  保存文件
:q  退出vim
:wq  保存退出
:q!  强制退出，改动不生效
:w!  强制保存
## 查看可执行文件需求的依赖库
ldd
### 向已有文件加入一行数据
echo "new line of text" | sudo tee -a /etc/apt/sources.list
#文件压缩和解压缩
## tar文件
### 解压
tar -xvf FileName.tar
### 压缩
tar -cvf filename.tar dirname
## zip文件
### 解压
unzip ***.zip
### 压缩
zip xx.zip DirName  zip 压缩包名 压缩文件名
zip -r xx.zip DirNmae  递归压缩，将目录下的所有文件全部压缩
## rar文件
### 解压
rar x filename.rar
### 压缩
rar a filename.rar dirname

# 一般提示Premission denied
在命令前添加sudo
##显示当前目录
pwd
## 查看程序的所有依赖项
ldd 程序名
## tmux
tmux是启用多会话窗口的工具
教程：https://www.ruanyifeng.com/blog/2019/10/tmux.html
## 编译库，可以使用make -j8使用多核编译，也可以-j4

## ubuntu无法截图时
在开机ubuntu后，点击右下角设置图标，选择x.org版本启动。这个版本不会有隐私权限问题，可以录屏
